module decnet;

import pool;


class DecNet {
    // DecNet version
    enum Version  = 1;

    // supported services by the client
    enum Services = 0b00000;


    // set by -p argument
    static __gshared ushort ListenPort = 4295;
}





// TODO: this is saving & restoration of pool's server
import vibe.core.net;
import vibe.data.json;
import std.file;

// Save all server connections to file
void saveToFile(Pool pool, string filename) {
    NetworkAddress[] servers;
    foreach (x; pool.peers) {
        if (x.isServer) {
            servers ~= x.address;
        }
    }

    auto tmp = servers.serializeToJsonString();
    filename.write(tmp);
}

// Restore all server connections from file
void loadFromFile(Pool pool, string filename) {
    auto tmp = filename.readText;

    auto peers = tmp.deserializeJson!(NetworkAddress[])();
    foreach (x; peers) {
        // add servers
    }
}

