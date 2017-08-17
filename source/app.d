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

Peer per;

shared static this() {
    runTask({
        auto dir = "todo pwd";

        writeln("Welcome to the DecNet!");
        writeln("Working directory: ", dir);

        DecNet.LivePool.connect();
        DecNet.LivePool.listen();
        sleep(1.seconds);

        user1();

        /*string cmd;
        do {
            cmd = readln().strip();

            writeln("have :", cmd);

        } while (cmd != "exit");

        */

        sleep(5.seconds);
        writeln("exiting...");
        DecNet.LivePool.disconnect();
    });
}


void user1() {
    per = new Peer("127.0.0.1", 4295, Networks.Live);
    sleep(1.seconds);
    per.connect();


    import message;
    auto msg = new Message(Command.GetAddress);

    sleep(1.seconds);
    per.sendMessage(msg);
    //per.disconnect();
}




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

