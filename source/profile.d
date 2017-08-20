module profile;

import network;
import address;

import std.array;
import std.algorithm.iteration;


class Profile {
    private int pyco;


    Address address() {
        return Address.fromString("ABCD");
    }
}


__gshared ProfileList[] Profiles;

struct ProfileList {
    Profile      profile;
    NetAddress[] netAddr;
}


ProfileList lookupProfile(Address address) {
    // look in table, files, mybe ask another node?
    auto res = Profiles.filter!(x => x.profile.address == address).array;

    return res ? res[0] : ProfileList.init;
}

