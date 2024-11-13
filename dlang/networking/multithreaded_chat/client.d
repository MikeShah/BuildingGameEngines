// @file chat/client.d
//
// After starting server (rdmd server.d)
// then start as many clients as you like with "rdmd client.d"
//
import std.socket;
import std.stdio;
import core.thread.osthread;

/// The purpose of the TCPClient class is to 
/// connect to a server and send messages.
class TCPClient{
	/// Constructor
	this(string host = "localhost", ushort port=50001){
		writeln("Starting client...attempt to create socket");
		// Create a socket for connecting to a server
		// Note: AddressFamily.INET tells us we are using IPv4 Internet protocol
		// Note: SOCK_STREAM (SocketType.STREAM) creates a TCP Socket
		//       If you want UDPClient and UDPServer use 'SOCK_DGRAM' (SocketType.DGRAM)
		mSocket = new Socket(AddressFamily.INET, SocketType.STREAM);
		// Socket needs an 'endpoint', so we determine where we
		// are going to connect to.
		// NOTE: It's possible the port number is in use if you are not
		//       able to connect. Try another one.
		mSocket.connect(new InternetAddress(host, port));
		writeln("Client conncted to server");
		// Our client waits until we receive at least one message
		// confirming that we are connected
		// This will be something like "Hello friend\0"
		char[80] buffer;
		auto received = mSocket.receive(buffer);
		writeln("(incoming from server) ", buffer[0 .. received]);
	}

	/// Destructor 
	~this(){
		// Close the socket
		mSocket.close();
	}

	// Purpose here is to run the client thread to constantly send data to the server.
	// This is your 'main' application code.
	// 
	// In order to make life a little easier, I will also spin up a new thread that constantly
	// receives data from the server.
	void run(){
		writeln("Preparing to run client");
		writeln("(me)",mSocket.localAddress(),"<---->",mSocket.remoteAddress(),"(server)");
		// Buffer of data to send out
		// Choose '80' bytes of information to be sent/received

		bool clientRunning=true;
		
		// Spin up the new thread that will just take in data from the server
		new Thread({
					receiveDataFromServer();
				}).start();
	
		write(">");
		while(clientRunning){
			foreach(line; stdin.byLine){
				write(">");
				// Send the packet of information
				mSocket.send(line);
			}
				// Now we'll immedietely block and await data from the server
		}

	}


	/// Purpose of this function is to receive data from the server as it is broadcast out.
	void receiveDataFromServer(){
		while(true){	
			// Note: It's important to recreate or 'zero out' the buffer so that you do not
			// 			 get previous data leftover in the buffer.
			char[80] buffer;
            // The key here is to observe the 'receive' portion of the bytes received.
            // Depending on our socket type, this could be a blocking operation, or otherwise
            // we do something when we receive some data from the server
			auto fromServer = buffer[0 .. mSocket.receive(buffer)];
			if(fromServer.length > 0){
				writeln("(from server)>",fromServer);
			}
		}
	}

	/// The client socket connected to a server
	Socket mSocket;
	
}


// Entry point to client
void main(){
	TCPClient client = new TCPClient();
	client.run();
}
