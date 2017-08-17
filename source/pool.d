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
    private Peer[]        m_peers;
    private TCPListener[] m_listener;
    private Networks      m_net;


    this(Networks net, NetworkAddress[] addrs = null) {
        m_net = net;

        if (addrs) {
            m_peers.reserve(addrs.length);
            foreach (x; addrs) {
                m_peers ~= new Peer(x, net);
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

    void connect() {
        foreach (x; m_peers) {
            x.connect();
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
        m_peers ~= new Peer(sock, m_net);
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

