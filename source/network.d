module network;


enum Networks : ubyte {
    TestNet = 0x18,
    Live    = 0x42
}


class Network {
    enum DefaultPort = 4295;
}


struct NetAddress {
align(1):
    long      timestamp;
    ulong     services;
    ubyte[16] address;
    ushort    port;
}
