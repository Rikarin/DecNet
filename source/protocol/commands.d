module protocol.commands;

import peer;
import message;

import protocol.ver;
import protocol.ping;
import protocol.query;
import protocol.commands;
import protocol.advertisement;

import std.conv;

import vibe.core.log;


// TODO: use dynamic array/
alias ParseCallback = void function(Peer, Message);
private enum ParseCallback[char[12]] ms_parseCallbacks = [
    "Version     " : &handleVersion,
    "VerAck      " : &handleVerAck,
    "Ping        " : &handlePing,
    "Pong        " : &handlePong,
    "GetAddress  " : &handleGetAddress,
    "Address     " : &handleAddress,
    "Query       " : &handleQuery,
    "Data        " : &handleData,
];

void parseMessage(Peer peer, Message msg) {
    logInfo("parsing command %s", msg.command);

    if (auto x = msg.command in ms_parseCallbacks) {
        (*x)(peer, msg);
    } else {
        logWarn("unknown command!");
    }
}

