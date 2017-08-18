module protocol.advertisement;

import peer;
import pool;
import message;
import network;

import std.datetime;
import std.bitmanip;

import vibe.core.log;


void handleGetAddress(Peer peer, Message msg) {
    NetAddress[] addrs;

    foreach (x;peer.pool.peers) {
        if (!x.isServer) {
            continue;
        }

        ubyte[16] full;
        auto a       = x.address;
        auto ad      = a.sockAddrInet4.sin_addr.s_addr;
        full[0 .. 4] = nativeToLittleEndian!uint(ad);

        NetAddress tmp = {
            timestamp : Clock.currTime.toUnixTime, // TODO: is this ok?
            services  : 0, // TODO
            address   : full,
            port      : a.port
        };

        addrs ~= tmp;
    }

    auto reply    = new Message(Command.Address);
    reply.payload = addrs;

    peer.send(reply);
}

void handleAddress(Peer peer, Message msg) {
    auto data = msg.payload!(NetAddress[]);

    foreach (x; data) {
        // if x is not in peer.pool.peers
        // TODO
        //auto peer = new Peer(x.address, x.port);
        //pool.add(peer);
    }

    logError("got %s", data);
}

