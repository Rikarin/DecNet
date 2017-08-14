module protocol.ping;

import peer;
import message;


void handlePing(Peer peer, Message msg) {
    auto response = new Message(Command.Pong);
    peer.sendMessage(response);
}

void handlePong(Peer peer, Message msg) {
    // TODO: reset time?
}

