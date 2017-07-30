


/**
 * Sendable container through the network
 */
class Packet {

    this() {

    }

    /**
     * Construct Packet from data received from socket
     */
    this(const(ubyte)[] data) {
        // TODO
    }


    // === Protocol
    private enum Magic : uint {
        Default = 0xDEADC0DE
    }

    private static struct Header {
    align(1):
        Magic magic;
        int   length;
    }


}

