module pool;

import peer;
import network;

import core.thread;
import std.socket : TcpSocket, SocketShutdown, InternetAddress;


class Pool {
    private Peer[]    m_peers;
    private Networks  m_nets;
    private TcpSocket m_listener;

    this(Networks nets, InternetAddress[] addrs = null) {
        m_nets     = nets;
        m_listener = new TcpSocket;

        if (addrs) {
            m_peers.reserve(addrs.length);
            foreach (x; addrs) {
                m_peers ~= new Peer(x, nets);
            }
        }
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
            x.disconnect();
        }

        m_listener.shutdown(SocketShutdown.BOTH);
        m_listener.close();
    }

    void listen() {
        // TODO: port
        auto addr = new InternetAddress(InternetAddress.ADDR_ANY, 4295);
        m_listener.bind(addr);
        m_listener.listen(128);

        new Thread(&_listen).start();

    }


    private void _listen() {
        import std.stdio;

        while (m_listener) {
            try {
                m_listener.accept();
                writeln("accepted connection");
            } catch (Exception e) {
                writeln("warning: ", e.msg);
                return;
            }
        }
    }
}

