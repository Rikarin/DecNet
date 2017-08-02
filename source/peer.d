module peer;

import message;
import network;

import std.datetime;
import std.socket : Socket, TcpSocket, SocketShutdown, InternetAddress;


/**
 * This class provides connection to enemy peer (client or server)
 */
class Peer {
    private Socket          m_socket;
    private Networks        m_nets;
    private SysTime         m_lastTime;
    private PeerState       m_state;
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

    // TODO: package?
    this(Socket socket, Networks nets) {
        m_nets   = nets;
        m_socket = socket;
    }

    SysTime lastTime() const {
        return m_lastTime;
    }

    void connect() {
        m_state = PeerState.Connecting;
        m_socket.connect(m_address);

        // TODO: set state when conected + lastTime
    }

    void disconnect() {
        m_state = PeerState.Disconnected;
        m_socket.shutdown(SocketShutdown.BOTH);
        m_socket.close();
    }

    void sendMessage(Message message) {
        m_lastTime = Clock.currTime();
        m_socket.send(message.toArray);
    }
}


enum PeerState : ubyte {
    Disconnected,
    Connecting,
    Connected,
    Ready
}

