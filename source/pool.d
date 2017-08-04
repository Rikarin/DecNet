module pool;

import peer;
import network;

import std.stdio;
import std.datetime;

import vibe.core.log;
import vibe.core.net;


// TODO: remove inactive peers after x mins
class Pool {
    enum Version = 1;

    private Peer[]        m_peers;
    private TCPListener[] m_listener;
    private Networks      m_nets;


    this(Networks nets, NetworkAddress[] addrs = null) {
        m_nets = nets;

        if (addrs) {
            m_peers.reserve(addrs.length);
            foreach (x; addrs) {
                m_peers ~= new Peer(x, nets);
            }
        }

        //new Thread(&_peersChecker).start();
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
            //x.disconnect();
        }

        foreach (x; m_listener) {
            // TODO: this shit is not supported yet
            x.stopListening();
        }
    }

    void listen() {
        // TODO: port
        m_listener = [listenTCP(4295, &_listen, "0.0.0.0")];
    }


    private void _listen(TCPConnection sock) {
        m_peers ~= new Peer(sock, m_nets);
        logInfo("accepted connection %s", sock.peerAddress);
    }

    private void _peersChecker() {
        while (m_peers || m_listener) {
            //Thread.sleep(5.minutes);

            try {
                foreach (x; m_peers) {
                    if (x.lastTime + 5.minutes < Clock.currTime()) {
                        // TODO : remove peer
                        // FIX: remove cast
                        writeln("removing peer ", cast()x);
                    }
                }

                writeln("peers checker");
            } catch (Exception e) {
                writeln("warning: ", e.msg);
                return;
            }
        }

        writeln("exiting peer checker...");
    }
}

