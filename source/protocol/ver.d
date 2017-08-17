module protocol.ver;

import peer;
import utils;
import decnet;
import network;
import message;

import std.datetime;

import vibe.core.log;


struct Version {
align(1):
    int        ver;
    ulong      services;
    long       timestamp;
    NetAddress toAddr;
    NetAddress fromAddr;
    ulong      nonce; // reserved for future usage
    string     userAgent;
}


Message versionMessage() {
    auto ret = new Message(Command.Version);
    Version ver = {
        ver       : DecNet.Version,
        services  : 0b0000000, // TODO
        timestamp : Clock.currTime().toUnixTime(),
        toAddr    : NetAddress.init, // TODO
        fromAddr  : NetAddress.init, // TODO
        nonce     : 0, // TODO
        userAgent : "client:official"
    };

    ret.payload = ver;
    return ret;
}

void handleVersion(Peer peer, Message msg) {
    auto ver = msg.payload!Version();
    logDiagnostic("received %s", ver);

    if (ver.ver != DecNet.Version) {
        logWarn("version mismatch");
        // TODO: send refuse??
        peer.disconnect();
    }

    auto response = new Message(Command.VerAck);
    peer.sendMessage(response);
}

void handleVerAck(Peer peer, Message msg) {
    peer.hasValidVersion = true;
    // TODO: something
}

