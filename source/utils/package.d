module utils;

import std.digest.sha : sha256Of;


T* payload(T, U)(U* data) {
    return cast(T *)(cast(ulong)data + U.sizeof);
}

ubyte[] payload(U)(U* data) {
    return (cast(ubyte *)(cast(ulong)data + U.sizeof))[0 .. data.length];
}

bool crcCheck(T)(T* data) {
    return data.checksum == *(cast(int *)sha256Of(sha256Of(data.payload)).ptr);
}

