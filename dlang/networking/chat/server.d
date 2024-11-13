// @file chat/server.d
//
// Start server first: rdmd server.d
// 
import std.socket;
import std.stdio;

// Entry point to Server
void main(){
	writeln("Starting server...");
	writeln("Server must be started before clients may join");
    auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
	scope(exit) listener.close();

	// Set the hostname and port for the socket
	// NOTE: It's possible the port number is in use if you are not able
	//  	 to connect. Try another one.
    string host = "localhost";
    ushort port = 50001;
	// When we 'bind' we are assigning an address with a port to a socket.
    listener.bind(new InternetAddress(host,port));
	// 'listen' means that a socket can 'accept' connections from another socket.
    // Allow 4 connections to be queued up in the 'backlog'
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

    // Message buffer will be 1024 bytes 
    char[1024] buffer;

    // Main application loop for the server
	writeln("Awaiting client connections");
    bool serverIsRunning=true;
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
            foreach(idx,client; connectedClientsList){
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
					// Adding +1 to client index to match number of clients.
					writeln("client",idx+1,">",buffer);
					// Send whatever was 'got' from the client.
                    client.send(buffer[0 .. got]);
                }
            }
			// The listener is ready to read
			// Client wants to connect so we accept here.
			if(readSet.isSet(listener)){
				auto newSocket = listener.accept();
				// Based on how our client is setup,
				// we need to send them an 'acceptance'
				// message, so that the client can
				// proceed forward.
				newSocket.send("Welcome from server, you are now in our connectedClientsList");
				// Add a new client to the list
				connectedClientsList ~= newSocket;
				writeln("> client",connectedClientsList.length," added to connectedClientsList");
			}
    	}
	}
}
