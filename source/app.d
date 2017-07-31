import std.stdio;

import address;
import public_key;
import private_key;


void main() {
	writeln("Edit source/app.d to start your project.");

    user1();
}


void user1() {
    auto privateKey = new PrivateKey;
    auto address    = privateKey.toAddress();


    auto str = privateKey.toPIF();
    writeln("len: ", str.length);
    writeln("test: ", str);


    if (PrivateKey.isValid(str)) {
        PrivateKey.fromPIF(str);
    }

}
