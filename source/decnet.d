module decnet;

import pool;
import network;


class DecNet {
    // DecNet version
    enum Version  = 1;

    // supported services by the client
    enum Services = 0b00000;


    // set by -p argument
    static __gshared ushort ListenPort = 4295;

    // default live pool
    static __gshared Pool LivePool;

    shared static this() {
        LivePool = new Pool(Networks.Live);
    }

    shared static ~this() {
        //LivePool.disconnect();
    }
}

