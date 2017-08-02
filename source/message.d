module message;

import utils;

//TODO: nonce??

/**
 * Sendable container through the network
 */
class Message {
    private const(char)[12] m_cmd;

    this(Command cmd) {
        m_cmd = ms_cmdTable[cmd];
    }

    this(string cmd) {
        m_cmd = "PICA        ";
        assert(false, "TODO");
    }



    /**
     * Construct Message from data received from socket
     */
    static Message fromBuffer(const(ubyte)[] data) {
        // TODO
        assert(false, "TODO");
    }



    static Message versionMessage() {
        auto ret = new Message(Command.Version);
        Version ver = {
            ver : 42,
        };

        return ret;
    }






    // === Protocol
    private enum Magic : uint {
        Default = 0xDEADC0DE
    }

    private static struct Header {
    align(1):
        Magic    magic;
        char[12] command;
        int      length;
        int      checksum;
    }

    private static struct Version {
    align(1):
        int   ver;
        ulong services;
        long  timestamp;
        byte[NetworkAddress.sizeof] toAddr;
        byte[NetworkAddress.sizeof] fromAddr;
        // TODO
    }

    private static struct NetworkAddress {
    align(1):
        // TODO
    }
}


enum Command : ubyte {
    Version,
    Ping,
    Pong,
}

private enum char[Message.Header.command.sizeof][Command] ms_cmdTable = [
    Command.Version : "Version     ",
    Command.Ping    : "Ping        ",
    Command.Pong    : "Pong        ",
];

