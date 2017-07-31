module utils.bigint;

import std.bigint;
import std.format;
import std.array     : array, join;
import std.algorithm : map, filter;


ubyte[] toArray(const BigInt bi) {
    import std.conv  : parse;
    import std.range : chunks;

    auto str = bi.toHex();
    return (str.length % 2 ? "0" ~ str : str)
        .filter!(x => x != '_')
        .chunks(2)
        .map!(x => x.parse!ubyte(16))
        .array();
}

string toHexString(const(ubyte)[] buffer) {
    return buffer.map!(x => format("%X", x)).join("");
}

