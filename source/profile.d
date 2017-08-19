module profile;

import network;
import address;

import std.array;
import std.algorithm.iteration;


class Profile {
    Address address() {
        assert(false, "TODO");
    }
}


__gshared ProfileList[] Profiles;

struct ProfileList {
    Profile      profile;
    NetAddress[] netAddr;
}


ProfileList lookupProfile(Address address) {
    // look in table, files, mybe ask another node?
    auto res = Profiles.filter!(x => x.profile.address is address).array;

    return res ? res[0] : ProfileList.init;
}

