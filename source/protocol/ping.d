module protocol.ping;

import peer;
import message;


void handlePing(Peer peer, Message msg) {
    peer.send(new Message(Command.Pong));
}

void handlePong(Peer peer, Message msg) {
    // Time is reset by receiving this message
}

