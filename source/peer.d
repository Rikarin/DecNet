module peer;


/**
 * This class provides connection to enemy peer (client or server)
 */
class Peer {
    private string m_ipAddress;
    private ushort m_port;
    private bool   m_isServer;

    bool isServer() const {
        return m_isServer;
    }
}

