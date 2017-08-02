module utils;

import std.digest.sha : sha256Of;


T* payload(T, U)(U* data) {
    return cast(T *)(cast(ulong)data + U.sizeof);
}

ubyte[] payload(U)(U* data) {
    import vibe.core.log;
    logError("size %s len %s", U.sizeof, data.length);
    return (cast(ubyte *)data)[U.sizeof .. U.sizeof + data.length];
}

bool crcCheck(T)(T* data) {
    import vibe.core.log;
    logError("%X %X", data.checksum, data.payload.calculateChecksum);
    return data.checksum == data.payload.calculateChecksum;
}

int calculateChecksum(const(ubyte)[] data) {
    return *(cast(int *)(sha256Of(sha256Of(data)).ptr));
}


