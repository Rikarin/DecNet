module data.bytebuffer;


final class ByteBuffer {
    private ubyte[] m_buffer;
    private size_t  m_pos;

    this() {

    }

    this(ubyte[] buffer) {
        resetData(buffer, 0);
    }

    size_t length() const {
        return m_buffer.length;
    }

    inout(ubyte)[] data() inout {
        return m_buffer;
    }

    size_t position() const {
        return m_pos;
    }

    void put(T)(size_t offset, T value) if (is(T == bool)) {
        put!ubyte(offset, value ? 0x01 : 0x00);
    }


    // TODO

    void resetData(ubyte[] buffer, size_t pos) {
        m_buffer = buffer;
        m_pos    = pos;
    }
}


private template verifyOffset(size_t length) {
    enum verifyOffset = "lol";
}

private template isByte(T) {
    static if (is(T == byte) || is(T == ubyte)) {
        enum isByte = true;
    } else {
        enum isByte = false;
    }
}

private template isNum(T) {
    static if (is(T == short) || is(T == ushort) ||
               is(T == int)   || is(T == ushort) ||
               is(T == long)  || is(T == ulong)  ||
               is(T == float) || is(T == double)) {
        enum isNum = true;
    } else {
        enum isNum = false;
    }
}

