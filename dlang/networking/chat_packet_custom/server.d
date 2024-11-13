// @file server.d
import std.socket;
import std.stdio;

import Packet : Packet;


void main(){
	writeln("Starting server...");
	writeln("Server must be started before clients may join");
    auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
	scope(exit) listener.close();

	// Set the hostname and port for the socket
    string host = "localhost";
    ushort port = 50002;
	// NOTE: It's possible the port number is in use if you are not able
	//  	 to connect. Try another one.
    listener.bind(new InternetAddress(host,port));
    // Allow 4 connections to be queued up
    listener.listen(4);

	// A SocketSet is equivalent to 'fd_set'
	// https://linux.die.net/man/3/fd_set
	// What SocketSet is used for, is to allow 
	// 'multiplexing' of sockets -- or put another
	// way, the ability for multiple clients
	// to connect a socket to this single server
	// socket.
    auto readSet = new SocketSet();
    Socket[] connectedClientsList;

    // Message buffer will be large enough to send/receive Packet.sizeof
    byte[Packet.sizeof] buffer;

    bool serverIsRunning=true;

    // Main application loop for the server
	writeln("Awaiting client connections");
    while(serverIsRunning){
		// Clear the readSet
        readSet.reset();
		// Add the server
        readSet.add(listener);
        foreach(client ; connectedClientsList){
            readSet.add(client);
        }
        
        // Handle each clients message
        if(Socket.select(readSet, null, null)){
            foreach(client; connectedClientsList){
				// Check to ensure that the client
				// is in the readSet before receving
				// a message from the client.
                if(readSet.isSet(client)){
					// Server effectively is blocked
					// until a message is received here.
					// When the message is received, then
					// we send that message from the 
					// server to the client
                    auto got = client.receive(buffer);
					
					// Setup a packet to echo back
					// to the client
					Packet p;
				    p.user 	= "connecting...";
					byte[4] field1 =  buffer[16 .. 20].dup;
					byte[4] field2 =  buffer[20 .. 24].dup;
					int f1 = *cast(int*)&field1;
					int f2 = *cast(int*)&field2;
					p.x = f1;
					p.y = f2;
					
					// Send raw bytes from packet,
                    client.send(p.GetPacketAsBytes());
                }
            }
			// The listener is ready to read
			// Client wants to connect so we accept here.
			if(readSet.isSet(listener)){
				auto newSocket = listener.accept();
				writeln("type of new Socket",typeid(newSocket));

				// Based on how our client is setup,
				// we need to send them an 'acceptance'
				// message, so that the client can
				// proceed forward.
				newSocket.send("Welcome from server, you are now in our connectedClientsList");
				// Add a new client to the list
				connectedClientsList ~= newSocket;
				writeln("> client",connectedClientsList.length," added to connectedClientsList");
			}

//			spawn(&sendWork, c, true);
    	}
	}
}

/*
CommandQueue[] commands;

void sendWork(Client c){
	while(clientsCurrentCommandQueuepos < commands.length){
		c.socket.send();
	}
}

struct Client{
	//socket;
	int pos;

}
*/
