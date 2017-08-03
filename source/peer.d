module peer;

import message;
import network;

import vibe.core.core;
import vibe.core.log;
import vibe.core.net;

import std.datetime;


/**
 * This class provides connection to enemy peer (client or server)
 */
class Peer {
    private TCPConnection  m_socket;
    private Networks       m_nets;
    private SysTime        m_lastTime;
    private PeerState      m_state;
    private NetworkAddress m_address;


    this(string address) {
        this(address, Network.DefaultPort, Networks.Live);
    }

    this(string address, Networks nets) {
        this(address, Network.DefaultPort, nets);
    }

    this(string address, ushort port, Networks nets) {
        auto net = resolveHost(address);
        net.port = port;

        this(net, nets);
    }

    this(NetworkAddress address, Networks nets) {
        m_nets    = nets;
        m_address = address;
        m_state   = PeerState.Disconnected;
    }

    // TODO: package?
    this(TCPConnection socket, Networks nets) {
        m_nets    = nets;
        m_socket  = socket;
        m_state   = PeerState.Connected;
        m_address = socket.remoteAddress;

        runTask(&_receive);
    }

    SysTime lastTime() const {
        return m_lastTime;
    }

    void connect() {
        m_state  = PeerState.Connecting;
        m_socket = connectTCP(m_address);
        m_state  = PeerState.Connected;

        runTask(&_receive);
        sendVersionMessage();
    }

    void disconnect() {
        if (m_state == PeerState.Disconnected) {
            logDebug("trying to disconnect already disconnected peer!");
            return;
        }

        m_state = PeerState.Disconnected;
        m_socket.close();
        m_socket = TCPConnection.init;
    }

    void sendMessage(Message message) {
        logInfo("Sending message %s", message.command);

        m_lastTime = Clock.currTime();
        m_socket.write(message.toArray);
    }


    private void sendVersionMessage() {
        auto msg = Message.versionMessage;

        sendMessage(msg);
    }

    private void _receive() {
        while (m_state == PeerState.Connected) {
            ubyte[Message.HeaderSize] header;

            try {
                m_socket.read(header);
                auto msg  = Message.fromBuffer(header);
                auto data = new ubyte[msg.length];

                m_socket.read(data);
                msg.appendData(data);

                parseMessage(this, msg);
            } catch (Exception e) {
                m_state = PeerState.Disconnected;
                logError("Disconnected");
                return;
            }
        }
    }
}


enum PeerState : ubyte {
    Disconnected,
    Connecting,
    Connected,
    Ready
}

