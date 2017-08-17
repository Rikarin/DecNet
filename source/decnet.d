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



import vibe.core.net;
import vibe.data.json;
import std.file;

// Save all server connections to file
void saveToFile(Pool pool, string filename) {
    auto tmp = pool.servers.serializeToJsonString();
    filename.write(tmp);
}

// Restore all server connections from file
void loadFromFile(Pool pool, string filename) {
    auto tmp = filename.readText;

    auto peers = tmp.deserializeJson!(NetworkAddress[])();
    assert(false, "TODO");
}
