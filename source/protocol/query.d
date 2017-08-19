module protocol.query;

import peer;
import address;
import message;
import network;
import profile;

import vibe.core.log;
import vibe.data.json;


// something like Query command. input is address of user,
// response should be full profile, part profile, possible addresses

enum QueryType {
    None    = 0 << 0,
    Address = 1 << 0,
    Profile = 1 << 1,

    Full    = Address | Profile
}

struct Query {
align(1):
    QueryType flags;
    Address[] address;
}

struct Data {
align(1):
    Address      address;
    Profile      profile;
    NetAddress[] netAddr;
}


void queryProfile(Address[] address, QueryType type) {
    Query query = {
        flags   : type,
        address : address
    };
}

void handleQuery(Peer peer, Message msg) {
    auto query = msg.payload!Query;
    Data[] data;

    bool qp = (query.flags & QueryType.Profile) == QueryType.Profile;
    bool qa = (query.flags & QueryType.Address) == QueryType.Address;

    foreach (x; query.address) {
        auto p = lookupProfile(x);
        if (p == ProfileList.init) {
            continue;
        }

        Data tmp = {
            address : x,
            profile : qp ? p.profile : null,
            netAddr : qa ? p.netAddr : null
        };
    }

    auto reply    = new Message(Command.Data);
    reply.payload = data;

    peer.send(reply);
}

void handleData(Peer peer, Message msg) {
    // add profiles to profile table?
}

