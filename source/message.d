module message;

import peer;
import pool;
import utils;
import protocol.commands;

import std.conv;

import vibe.core.log;
import vibe.core.net;
import vibe.data.json;


//TODO: nonce??

// Implementation in protocol/commands.d
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


/**
 * Sendable container through the network
 */
class Message {
    private Header  m_header;
    private ubyte[] m_payload;

    private this() {

    }

    this(Command cmd) {
        string tmp     = cmd.to!string;
        m_header.magic = Magic.Value;

        m_header.command[] = ' ';
        m_header.command[0 .. tmp.length] = tmp[];
    }

    this(char[12] cmd) {
        m_header.command = cmd;
    }

    const(char)[12] command() const {
        return m_header.command;
    }

    int length() const {
        return m_header.length;
    }

    T payload(T)() {
        return deserializeJson!T(cast(string)m_payload);
    }

    void payload(T)(T payload) {
        auto pl = payload.serializeToJsonString();

        m_payload         = cast(ubyte[])pl;
        m_header.length   = cast(int)m_payload.length;
        m_header.checksum = m_payload.calculateChecksum;
    }


    // === Conversion
    const(ubyte)[] toArray() const {
        return (cast(ubyte *)&m_header)[0 .. Header.sizeof] ~ m_payload;
    }

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


    // ===
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
}

