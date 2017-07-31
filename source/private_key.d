module private_key;

import address;
import network;
import public_key;
import crypto.base58;
import utils.bigint;

import std.bigint;
import std.random;
import std.digest.sha : sha256Of;

alias PrivateKeyException = Exception;


class PrivateKey {
    private BigInt m_data;


    // Creates new private key
    this() /*immutable*/ {
        m_data = uniform(1, 0xFF);

        // TODO: remove pseudo-random generation
        foreach (i; 0 .. 62) {
            m_data <<= 8;
            m_data += uniform(0, 0xFF);
        }

        writeln("new: ", m_data);
    }

    this(string hash) {
        m_data = "0x" ~ hash;

        writeln("this: ", m_data);
    }



    // === Validation
    bool isValid() const nothrow {
        assert(false, "TODO");
    }

    void validate() const {
        throw new PrivateKeyException("Key is not valid!");
    }



    // === Conversion
    PublicKey toPublicKey() const { // TODO retun immutable PK?
        return new PublicKey(); // TODO
    }

    Address toAddress(Networks networks = Networks.Live) const {
        return new Address(toPublicKey());
    }



    // === PIF serialization/deserialization
    string toPIF() const {
        auto key = [ubyte(0x42)] ~ m_data.toArray();
        auto crc = key.sha256Of().sha256Of();
        key     ~= crc[0 .. 4];

        return Base58.encode(key);
    }

    static PrivateKey fromPIF(string pif) {
        auto key = Base58.decode(pif);
        auto crc = key[$ - 4 .. $];
        // TODO, type??
        key      = key[1 .. $ - 4];


        writeln(" hash: ", key.toHexString());
        auto ret = new PrivateKey(key.toHexString());

        assert(false, "TODO");
    }
}

import std.stdio;
