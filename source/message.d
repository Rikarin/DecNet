module message;

import peer;
import pool;
import utils;

import protocol.ver;
import protocol.ping;

import vibe.core.log;
import vibe.core.net;


//TODO: nonce??

/**
 * Sendable container through the network
 */
class Message {
    private Header  m_header;
    private ubyte[] m_payload;

    private this() {

    }

    this(Command cmd) {
        m_header.magic   = Magic.Value;
        m_header.command = ms_cmdTable[cmd];
    }

    this(string cmd) {
        assert(false, "TODO");
    }

    const(char)[12] command() const {
        return m_header.command;
    }

    int length() const {
        return m_header.length;
    }

    const(ubyte)[] toArray() const {
        return (cast(ubyte *)&m_header)[0 .. Header.sizeof] ~ m_payload;
    }

    T* payload(T)() {
        return cast(T *)m_payload.ptr;
    }

    void appendData(ubyte[] data) {
        m_payload         = data.dup;
        m_header.length   = cast(int)data.length;
        m_header.checksum = data.calculateChecksum;
    }


    // === Creates Message from Buffer or Stream
    static Message fromBuffer(const(ubyte)[] data) {
        assert(false, "TODO");
        // TODO: this should create whole msg at once
    }

    static Message fromStream(TCPConnection stream) {
        auto ret = new Message;

        // Read and validate Header
        stream.read((cast(ubyte *)&ret.m_header)[0 .. Header.sizeof]);
        if (ret.m_header.magic != Magic.Value) {
            logWarn("magic mismatch");
            return null;
        }

        // Read additional data and validate
        if (ret.m_header.length) {
            ret.m_payload = new ubyte[ret.m_header.length];
            stream.read(ret.m_payload);

            if (ret.m_header.checksum != ret.m_payload.calculateChecksum) {
                logError("wrong checksum");
                return null;
            }
        }

        return ret;
    }


    // === Protocol
    private enum Magic {
        Value = 0x2A83F542
    }

    private static struct Header {
    align(1):
        Magic    magic;
        char[12] command;
        int      length;
        int      checksum;
    }


    private static struct Query {
    align(1):
        // TODO: flags: full profile, profile, addresses only
    int count; // max 128 profiles at the same time?
    // TODO: payload
        //byte[25] address;
    }
}

struct NetAddress {
align(1):
    // TODO
}


enum Command : ubyte {
    Version,
    VerAck,
    Ping,
    Pong,

    GetAddress,
    Address,
    Query,
    Data,
}

private enum char[Message.Header.command.sizeof][Command] ms_cmdTable = [
    Command.Version    : "Version     ",
    Command.VerAck     : "VerAck      ",
    Command.Ping       : "Ping        ",
    Command.Pong       : "Pong        ",

    Command.GetAddress : "GetAddress  ",
    Command.Address    : "Address     ",
    Command.Query      : "Query       ",
    Command.Data       : "Data        ",
];

// something like Query command. input is address of user,
// response should be full profile, part profile, possible addresses




// TODO: move this to another file?
// TODO: use dynamic array/
alias ParseCallback = void function(Peer, Message);
private enum ParseCallback[char[12]] ms_parseCallbacks = [
    ms_cmdTable[Command.Version]    : &handleVersion,
    ms_cmdTable[Command.VerAck]     : &handleVerAck,
    ms_cmdTable[Command.Ping]       : &handlePing,
    ms_cmdTable[Command.Pong]       : &handlePong,

    ms_cmdTable[Command.GetAddress] : &handleGetAddress,
    ms_cmdTable[Command.Address]    : &handleAddress,
    ms_cmdTable[Command.Query]      : &handleQuery,
    ms_cmdTable[Command.Data]       : &handleData,
];


void parseMessage(Peer peer, Message msg) {
    logInfo("parsing command %s", msg.command);

    if (auto x = msg.command in ms_parseCallbacks) {
        (*x)(peer, msg);
    } else {
        logWarn("unknown command!");
    }
}


void handleGetAddress(Peer peer, Message msg) {
    // return all known peers (servers only)
}

void handleAddress(Peer peer, Message msg) {
    // TODO: add peers to pool
}

void handleQuery(Peer peer, Message msg) {
    // send Data cmd
}

void handleData(Peer peer, Message msg) {
    // add profiles to profile table?
}

