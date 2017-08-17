module protocol.query;

import peer;
import address;
import message;
import network;

import public_key;
import vibe.core.log;
import vibe.data.json;


// something like Query command. input is address of user,
// response should be full profile, part profile, possible addresses

enum QueryType {
    None      = 0 << 0,
    Addresses = 1 << 0,
    Profile   = 1 << 1,
    Full      = 1 << 2,
}

struct Profile { // TODO: move this
    int foo;
    int bar;
    NetAddress[] addresses;
}

struct Query {
align(1):
    QueryType flags;
    ubyte     count;
    Address[] profileAddresses;
}

void handleQuery(Peer peer, Message msg) {
    // send Data cmd
}

void handleData(Peer peer, Message msg) {
    // add profiles to profile table?
}

