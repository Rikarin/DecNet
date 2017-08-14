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

    const(char)[12] command() const {
        return m_header.command;
    }

    int length() const {
        return m_header.length;
    }

    const(ubyte)[] toArray() const {
        return (cast(ubyte *)&m_header)[0 .. Header.sizeof] ~ m_data;
    }

    T* payload(T)() {
        return cast(T *)m_data.ptr;
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

// mohlo by byt toto pouzite na quernutie vsetkych profilov??
// ci je to zbytocne? zatazovalo by to server? providovalo by to vsetky
// profily po sieti a mohlo by to byt zneuzite na analyzu dat?
// analyza dat = cena za poskytovanie sluzieb




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

