module protocol.ver;

import peer;
import utils;
import decnet;
import message;

import std.datetime;

import vibe.core.log;


struct Version {
align(1):
    int   ver;
    ulong services;
    long  timestamp;
    byte[NetAddress.sizeof] toAddr;
    byte[NetAddress.sizeof] fromAddr;
    ulong nonce;
    // TODO
}


Message versionMessage() {
    auto ret = new Message(Command.Version);
    Version ver = {
        ver       : DecNet.Version,
        services  : 0b0000000, // TODO
        timestamp : Clock.currTime().toUnixTime()
        // TODO
    };

    ret.appendData((cast(ubyte *)&ver)[0 .. Version.sizeof]);
    return ret;
}

void handleVersion(Peer peer, Message msg) {
    auto ver = msg.payload!Version();
    logDiagnostic("received %s", *ver);


    if (ver.ver != DecNet.Version) {
        logWarn("version mismatch");
        // TODO: send refuse?? & disconnect peer
    }

    auto response = new Message(Command.VerAck);
    peer.sendMessage(response);
}

void handleVerAck(Peer peer, Message msg) {
    peer.hasValidVersion = true;
    // TODO: something
}

