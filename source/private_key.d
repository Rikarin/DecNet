module private_key;

import network;
import public_key;
import crypto.base58;
import utils.bigint;

import std.bigint;
import std.random;
import std.digest.sha : sha256Of;

alias PrivateKeyException = Exception;


class PrivateKey {
    enum PIFLength = 51;

    private BigInt m_data; // TODO

    // Creates new private key
    this() /*immutable*/ {
        m_data = uniform(0x10, 0xFF);

        // TODO: remove pseudo-random generation
        foreach (i; 0 .. 31) {
            m_data <<= 8;
            m_data += uniform(0, 0xFF);
        }
    }

    this(string hex) {
        m_data = BigInt("0x" ~ hex);
    }


    // === Validation
    static bool isValid(string pif) nothrow {
        try {
            if (pif.length != PIFLength) {
                return false;
            }

            auto tmp = parsePIF(pif);
            auto crc = tmp.key.sha256Of().sha256Of();

            if (crc == tmp.crc) {
                return true;
            }

            return false;
        } catch (Exception e) {
            return false;
        }
    }

    static void validate(string pif) {
        if (pif.length != PIFLength) {
            throw new PrivateKeyException("Length doesn't match");
        }

        auto tmp = parsePIF(pif);
        auto crc = tmp.key.sha256Of().sha256Of();

        if (crc != tmp.crc) {
            throw new PrivateKeyException("CRC mismatch");
        }
    }


    // === Conversion
    PublicKey toPublicKey() const { // TODO retun immutable PK?
        // TODO: convert to hex public and call ctor
        return new PublicKey(m_data.toHex()); // FIX: this is shit
    }


    // === PIF serialization/deserialization
    string toPIF() const {
        auto key = [ubyte(Networks.Live)] ~ m_data.toArray();
        auto crc = key.sha256Of().sha256Of();
        key     ~= crc[0 .. 4];

        return Base58.encode(key);
    }

    static PrivateKey fromPIF(string pif) {
        return new PrivateKey(parsePIF(pif).key.toHexString());
    }

    private static auto parsePIF(string pif) {
        auto key  = Base58.decode(pif);
        auto crc  = key[$ - 4 .. $];
        auto type = cast(Networks)key[0];
        key       = key[1 .. $ - 4];

        static struct ParsedPIF {
            ubyte[]  key;
            ubyte[]  crc;
            Networks type;
        }

        return ParsedPIF(key, crc, type);
    }
}

