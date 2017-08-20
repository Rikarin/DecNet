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
    QueryType flags;
    Address[] address;
}


Message queryMessage(Address[] address, QueryType type = QueryType.Full) {
    Query query = {
        flags   : type,
        address : address
    };

    auto msg    = new Message(Command.Query);
    msg.payload = query;

    return msg;
}

void handleQuery(Peer peer, Message msg) {
    auto query = msg.payload!Query;
    ProfileList[] data;
    logError("1 got %s", query);

    bool qp = (query.flags & QueryType.Profile) == QueryType.Profile;
    bool qa = (query.flags & QueryType.Address) == QueryType.Address;

    foreach (x; query.address) {
        auto p = lookupProfile(x);
        if (p == ProfileList.init) {
            continue;
        }

        if (!qp) {
            p.profile = null;
        }

        if (!qa) {
            p.netAddr = null;
        }

        data ~= p;
    }

    auto reply    = new Message(Command.Data);
    reply.payload = data;

    peer.send(reply);
}

void handleData(Peer peer, Message msg) {
    auto payload = msg.payload!(ProfileList[]);
    logError("got %s", payload);

    // TODO add profiles to profile table?
}

