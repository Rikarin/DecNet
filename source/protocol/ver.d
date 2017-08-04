module protocol.ver;

import peer;
import pool;
import utils;
import message;

import vibe.core.log;


struct Version {
align(1):
    int   ver;
    ulong services;
    long  timestamp;
    byte[NetAddress.sizeof] toAddr;
    byte[NetAddress.sizeof] fromAddr;
    // TODO
}


Message versionMessage() {
    auto ret = new Message(Command.Version);
    Version ver = {
        ver : 42,
    };

    ret.appendData((cast(ubyte *)&ver)[0 .. Version.sizeof]);
    return ret;
}

void handleVersion(Peer peer, Message msg) {
    auto ver = msg.payload!Version();
    if (ver.ver != Pool.Version) {
        logWarn("version mismatch");
        // TODO: send refuse?? & disconnect peer
    }

    auto response = new Message(Command.VerAck);
    peer.sendMessage(response);
}

void handleVerAck(Peer peer, Message msg) {
    // TODO: something
}

