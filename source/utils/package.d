module utils;

import std.digest.sha : sha256Of;


bool crcCheck(T)(T* data) {
    import vibe.core.log;
    logError("%X %X", data.checksum, data.payload.calculateChecksum);
    return data.checksum == data.payload.calculateChecksum;
}

int calculateChecksum(const(ubyte)[] data) {
    return *(cast(int *)(sha256Of(sha256Of(data)).ptr));
}

