module packet;

import std.digest.sha : sha256Of;


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

    private static struct Message {
    align(1):
        Magic    magic;
        char[12] command;
        int      length;
        int      checksum;
    }

    void lol() {
        Message* msg;
        auto sub = msg.payload!Sub();
        msg.crcCheck();
    }

    private static struct Sub { }
}


T* payload(T, U)(U* data) {
    return cast(T *)(cast(ulong)data + U.sizeof);
}

ubyte[] payload(U)(U* data) {
    return (cast(ubyte *)(cast(ulong)data + U.sizeof))[0 .. data.length];
}

bool crcCheck(T)(T* data) {
    return data.checksum == *(cast(int *)sha256Of(sha256Of(data.payload)).ptr);
}

