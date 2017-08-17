module protocol.query;

import peer;
import message;


// something like Query command. input is address of user,
// response should be full profile, part profile, possible addresses


struct Query {
align(1):
    // TODO: flags: full profile, profile, addresses only
    int count; // max 128 profiles at the same time?
    // TODO: payload
    //byte[25] address;
}

void handleQuery(Peer peer, Message msg) {
    // send Data cmd
}

void handleData(Peer peer, Message msg) {
    // add profiles to profile table?
}

