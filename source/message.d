module message;

import peer;
import utils;

import vibe.core.log;
import vibe.core.net;

//TODO: nonce??

/**
 * Sendable container through the network
 */
class Message {
    private Header  m_header;
    private ubyte[] m_data;

    private this() {

    }

    this(Command cmd) {
        m_header.magic   = Magic.Default;
        m_header.command = ms_cmdTable[cmd];
    }

    this(string cmd) {
        assert(false, "TODO");
    }


    string command() const {
        return m_header.command.idup;
    }

    int length() const {
        return m_header.length;
    }

    const(ubyte)[] toArray() const {
        return (cast(ubyte *)&m_header)[0 .. Header.sizeof] ~ m_data;
    }

    void appendData(ubyte[] data) {
        m_data = data.dup;

        if (m_header.length) {
            if (m_header.checksum != m_data.calculateChecksum) {
                logError("wrong checksup");
                // TODO: throw?
            }
        } else {
            m_header.length   = cast(int)m_data.length;
            m_header.checksum = m_data.calculateChecksum;
        }
    }


    /**
     * Construct Message from data received from socket
     */
    static Message fromBuffer(const(ubyte)[] data) {
        auto ret     = new Message;
        ret.m_header = *cast(Header *)data.ptr;

        if (ret.m_header.magic != Magic.Default) {
            logWarn("Magic mismatch");
        }

        return ret;
    }



    static Message versionMessage() {
        auto ret = new Message(Command.Version);
        Version ver = {
            ver : 42,
        };

        ret.appendData((cast(ubyte *)&ver)[0 .. Version.sizeof]);

        return ret;
    }






    // === Protocol
    enum HeaderSize = Header.sizeof;

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
    VerAck,
    Ping,
    Pong,
}

private enum char[Message.Header.command.sizeof][Command] ms_cmdTable = [
    Command.Version : "Version     ",
    Command.VerAck  : "VerAck      ",
    Command.Ping    : "Ping        ",
    Command.Pong    : "Pong        ",
];





// TODO: move this to another file?

void handleVersion(Peer peer, Message msg) {
    // TODO: check some crap

    auto response = new Message(Command.VerAck);
    peer.sendMessage(response);
}







