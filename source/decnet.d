module decnet;


class DecNet {
    enum Version  = 1;
    enum Services = 0b00000;

    // set this by -p argument
    static __gshared ushort ListenPort = 4295;
}

