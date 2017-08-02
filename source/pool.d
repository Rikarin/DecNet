module pool;

import peer;
import network;

import core.thread;
import core.sync.mutex;

import std.stdio;
import std.datetime;
import std.socket : TcpSocket, SocketShutdown, InternetAddress;

import vibe.core.net;


// TODO: remove inactive peers after x mins
class Pool {
    private __gshared Peer[]    m_peers;
    private __gshared TcpSocket m_listener;
    private shared Networks     m_nets;
    private shared Mutex        m_peersLock;


    this(Networks nets, InternetAddress[] addrs = null) {
        m_nets      = nets;
        m_peersLock = new shared Mutex;
        m_listener  = new TcpSocket;

        if (addrs) {
            m_peers.reserve(addrs.length);
            foreach (x; addrs) {
                m_peers ~= new Peer(x, nets);
            }
        }

        new Thread(&_peersChecker).start();
    }

    size_t peerCount() const {
        return m_peers.length;
    }

    void connect() {
        synchronized (m_peersLock) {
            foreach (x; m_peers) {
                x.connect();
            }
        }
    }

    void disconnect() {
        synchronized (m_peersLock) {
            foreach (x; m_peers) {
                x.disconnect();
            }
        }

        m_listener.shutdown(SocketShutdown.BOTH);
        m_listener.close();
        m_listener = null;
    }

    void listen() {
        // TODO: port
        auto addr = new InternetAddress(InternetAddress.ADDR_ANY, 4295);
        m_listener.bind(addr);
        m_listener.listen(128);

        new Thread(&_listen).start();
    }


    private void _listen() {
        while (m_listener) {
            try {
                auto sock = m_listener.accept();
                m_peers  ~= new Peer(sock, m_nets);

                writeln("accepted connection");
            } catch (Exception e) {
                writeln("warning: ", e.msg);
                return;
            }
        }
    }

    private void _peersChecker() {
        while (m_peers || m_listener) {
            Thread.sleep(5.minutes);

            try {
                synchronized (m_peersLock) {
                    foreach (x; m_peers) {
                        if (x.lastTime + 5.minutes < Clock.currTime()) {
                            // TODO : remove peer
                            // FIX: remove cast
                            writeln("removing peer ", cast()x);
                        }
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

