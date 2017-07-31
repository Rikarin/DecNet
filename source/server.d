module server;

import peer;
import packet;

/**
 * I'm server so I'm collecting and distributing profiles
 *
 * TODO: listen on specific port
 */
class Server : Peer {
    private static Peer[] ms_servers; // Default servers
    private Peer[] m_peers;

    static this() {
        // TODO: load servers from file and fill ms_servers
    }

    /**
     * distribute packet throug the network
     */
    static void distribute(const Packet message) {

    }
}

