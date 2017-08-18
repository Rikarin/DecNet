module pool;

import peer;
import decnet;
import network;

import std.array;
import std.datetime;
import std.algorithm.searching : canFind;
import std.algorithm.iteration : filter;

import vibe.core.log;
import vibe.core.net;
import vibe.core.core;


class Pool {
    static __gshared Pool Live;
    static __gshared Pool Test;

    private Networks      m_net;
    private Peer[]        m_peers;
    private TCPListener[] m_listener;


    shared static this() {
        version (TestNetwork) {
            Test = new Pool(Networks.Test);
        } else {
            auto rikarin = resolveHost("rikarin.org");
            rikarin.port = 4295;

            Live = new Pool(Networks.Live, [rikarin]);
        }
    }

    this(Networks net, NetworkAddress[] addrs = null) {
        m_net = net;

        if (addrs) {
            m_peers.reserve(addrs.length);
            foreach (x; addrs) {
                m_peers ~= new Peer(x, net);
                m_peers[$ - 1].isServer = true;
                m_peers[$ - 1].pool     = this;
            }
        }

        runTask(&_peersChecker);
    }

    Peer[] peers() {
        return m_peers;
    }

    size_t peerCount() const {
        return m_peers.length;
    }

    void add(Peer peer) {
        foreach (ref x; m_peers) {
            if (x is peer) {
                if (x.state == PeerState.Disconnected) {
                    x = peer;
                    return;
                }

                logWarn("Peer already connected!");
                // TODO: throw?
                return;
            }
        }

        m_peers  ~= peer;
        peer.pool = this;
    }

    void remove(Peer peer) {
        m_peers   = m_peers.filter!(x => x != peer).array;
        peer.pool = null;
    }

    void connect() {
        foreach (x; m_peers) {
            try {
                x.connect();
            } catch (Exception e) {
                logError("Cannot connect to peer %s. Skipping...", x.address.toString);
            }
        }
    }

    void disconnect() {
        foreach (x; m_peers) {
            // TODO: fix this x.disconnect();
        }

        foreach (x; m_listener) {
            x.stopListening();
        }
    }

    void listen() {
        m_listener = [listenTCP(DecNet.ListenPort, &_listen, "0.0.0.0")];
    }


    private void _listen(TCPConnection sock) {
        auto peer = new Peer(sock, m_net);
        peer.pool = this;
        m_peers  ~= peer;

        logInfo("accepted connection %s", sock.peerAddress);
    }

    private void _peersChecker() {
        while (m_peers || m_listener) {
            sleep(3.hours);

            try {
                auto ct = Clock.currTime() - 5.minutes;
                m_peers = m_peers.filter!(x => x.lastTime < ct).array;
                logInfo("peers checker");
            } catch (Exception e) {
                logInfo("warning: ", e.msg);
                return;
            }
        }

        logInfo("exiting peer checker...");
    }
}

