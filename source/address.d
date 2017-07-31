module address;

import network;
import public_key;
import crypto.base58;

import std.digest.sha    : sha256Of;
import std.digest.ripemd : ripemd160Of;


class Address {
    private ubyte[25] m_data; // 1 + 20 + 4

    this(const PublicKey key, Networks networks) {
        auto hash = ripemd160Of(sha256Of(key.toString()));
        auto crc  = sha256Of(sha256Of(m_data[1 .. $ - 4]));

        m_data[0] = networks == Networks.Live ? 0x00 : 0xFF;
        m_data[1 .. $ - 4] = hash;
        m_data[$ - 4 .. $] = crc[0 .. 4];
    }


    // === Validation
    static bool isValid(string key) nothrow {
        assert(false, "TODO");
    }

    static void validate(string key) {
        assert(false, "TODO");
    }


    // === Conversions
    override string toString() const {
        return Base58.encode(m_data);
    }


    static Address fromString(string address) {
        assert(false, "TODO");
    }

    static Address fromPublicKey(string address) {
        assert(false, "TODO");
    }
}

