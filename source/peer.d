module peer;

import message;
import network;

import std.datetime;
import std.socket : TcpSocket, SocketShutdown, InternetAddress;


/**
 * This class provides connection to enemy peer (client or server)
 */
class Peer {
    private TcpSocket m_socket;
    private Networks  m_nets;
    private SysTime   m_lastPing;
    private InternetAddress m_address;


    this(string address) {
        this(address, Network.DefaultPort, Networks.Live);
    }

    this(string address, Networks nets) {
        this(address, Network.DefaultPort, nets);
    }

    this(string address, ushort port, Networks nets) {
        this(new InternetAddress(address, port), nets);
    }

    this(InternetAddress address, Networks nets) {
        m_nets    = nets;
        m_address = address;
        m_socket  = new TcpSocket;
    }

    void connect() {
        m_socket.connect(m_address);
    }

    void disconnect() {
        //set state
        m_socket.shutdown(SocketShutdown.BOTH);
        m_socket.close();
    }

    void sendMessage(Message message) {
        m_lastPing = Clock.currTime();
        // TODO send to tcp
    }

}


enum PeerState : ubyte {
    Disconnected,
    Connecting,
    Connected,
    Ready
}



// TODO: flags??
enum PeerType : uint {
    LOL
}

