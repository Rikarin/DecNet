module crypto.base58;

import std.conv;


class Base58 {
@safe:
    private static immutable Alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
    private static int[] Indexes      = new int[128];

    static this() {
        foreach (ref x; Indexes) {
            x = -1;
        }

        foreach (int i, x; Alphabet) {
            Indexes[x] = i;
        }
    }

    static string encode(const(ubyte)[] buffer) {
        if (!buffer.length) {
            return "";
        }

        int zeros = 0;
        while (zeros < buffer.length && buffer[zeros] == 0) {
          zeros++;
        }

        // Convert base-256 digits to base-58 digits (plus conversion to ASCII characters)
        auto input = new ubyte[buffer.length];
        input[0 .. buffer.length] = buffer[0 .. $]; // since we modify it in-place
        auto encoded     = new char[input.length * 2]; // upper bound
        auto outputStart = encoded.length;

        for (int inputStart = zeros; inputStart < input.length; ) {
              encoded[--outputStart] = Alphabet[divmod(input, inputStart, 256, 58)];

              if (input[inputStart] == 0) {
                ++inputStart; // optimization - skip leading zeros
              }
        }

        // Preserve exactly as many leading encoded zeros in output as there were leading zeros in input.
        while (outputStart < encoded.length && encoded[outputStart] == Alphabet[0]) {
            ++outputStart;
        }

        while (--zeros >= 0) {
            encoded[--outputStart] = Alphabet[0];
        }

        // Return encoded string (including encoded leading zeros).
        return encoded[outputStart .. encoded.length].to!string();
    }

    static ubyte[] decode(string input) {
        if (!input.length) {
            return new ubyte[0];
        }

        // Convert the base58-encoded ASCII chars to a base58 byte sequence (base58 digits).
        ubyte[] input58 = new ubyte[input.length];
        for (int i = 0; i < input.length; ++i) {
            char c = input[i];
            int digit = c < 128 ? Indexes[c] : -1;

            if (digit < 0) {
                throw new Exception("Illegal character " ~ c ~ " at position " ~ to!string(i));
            }

            input58[i] = cast(ubyte)digit;
        }

        // Count leading zeros.
        int zeros = 0;
        while (zeros < input58.length && input58[zeros] == 0) {
          ++zeros;
        }

        // Convert base-58 digits to base-256 digits.
        ubyte[] decoded  = new ubyte[input.length];
        int outputStart = cast(int)decoded.length;

        for (int inputStart = zeros; inputStart < input58.length; ) {
            decoded[--outputStart] = divmod(input58, inputStart, 58, 256);
            if (input58[inputStart] == 0) {
                ++inputStart; // optimization - skip leading zeros
            }
        }

        // Ignore extra leading zeroes that were added during the calculation.
        while (outputStart < decoded.length && decoded[outputStart] == 0) {
          ++outputStart;
        }

        // Return decoded data (including original number of leading zeros).
        return decoded[outputStart - zeros .. decoded.length];
    }

    private static byte divmod(ubyte[] number, int firstDigit, int base, int divisor) {
        // this is just long division which accounts for the base of the input digits
        int remainder = 0;

        for (int i = firstDigit; i < number.length; i++) {
          int digit = cast(int) number[i] & 0xFF;
          int temp  = remainder * base + digit;
          number[i] = cast(ubyte)(temp / divisor);
          remainder = temp % divisor;
        }

        return cast(ubyte)remainder;
    }
}

