module app;

import decnet;
import peer;
import pool;
import address;
import network;
import public_key;
import private_key;

import std.stdio;
import std.string;
import std.datetime;

import core.thread;

import vibe.core.core;
import vibe.core.task;

// TODO: -D path/to/dir/with/private_key + cache for my profile
// TODO: -p listening port, default 4295

shared static this() {
    runTask({
        auto dir = "todo pwd";
        writeln("Welcome to the DecNet!");
        writeln("Working directory: ", dir);

        liveServer();
        test();
    });
}

void liveServer() {
    Pool.Live.connect();
    Pool.Live.listen();
}




void test() {
    sleep(1.seconds);

    user1();

    sleep(5.seconds);
    writeln("exiting...");
    Pool.Live.disconnect();
}

void user1() {
    auto per = new Peer("127.0.0.1", 4295, Networks.Live);
    Pool.Live.add(per);

    sleep(1.seconds);
    per.connect();

    import message;
    auto msg = new Message(Command.GetAddress);

    sleep(1.seconds);
    per.send(msg);


    import profile;
    Profiles ~= ProfileList(new Profile);

    sleep(1.seconds);
    import protocol.query;
    per.send(queryMessage([Address.fromString("ABCD")]));
    //per.disconnect();
}
    /*string cmd;
    do {
        cmd = readln().strip();

        writeln("have :", cmd);

    } while (cmd != "exit");

    */

void user(string[] cmd) {
    if (!cmd.length) {
        writeln("error: 0 length");
        return;
    }

    switch (cmd[0]) {
        case "create":
            break;

        default:
            writeln("error: unknown command");
    }
}

