module public_key;

import address;
import network;
import private_key;

import std.bigint;


class PublicKey {
    private BigInt m_data;

    this(const PrivateKey privateKey) {
        // HACK??
        m_data = privateKey.toPublicKey().m_data;
    }

    this(string hex) {
        m_data = BigInt("0x" ~ hex);
    }


    // === Validation
    static bool isValid(string key) nothrow {
        assert(false, "TODO");
    }

    static void validate(string key) {
        assert(false, "TODO");
    }


    // === Conversion
    Address toAddress(Networks networks = Networks.Live) const {
        return new Address(this, networks);
    }

    override string toString() const {
        return m_data.toHex(); // TODO: check this
    }


    static PublicKey fromString(string value) {
        validate(value);
        return new PublicKey(value);
    }
}

