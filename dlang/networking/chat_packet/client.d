import std.socket;
import std.stdio;

// Packet
import Packet : Packet;

void main(){
	writeln("Starting client...attempt to create socket");
    // Create a socket for connecting to a server
    auto socket = new Socket(AddressFamily.INET, SocketType.STREAM);
	// Socket needs an 'endpoint', so we determine where we
	// are going to connect to.
	// NOTE: It's possible the port number is in use if you are not
	//       able to connect. Try another one.
    socket.connect(new InternetAddress("localhost", 50001));
	scope(exit) socket.close();
	writeln("Connected");

    // Buffer of data to send out
    char[Packet.sizeof] buffer;
    auto received = socket.receive(buffer);

    writeln("On Connect: ", buffer[0 .. received]);
	write(">");
    foreach(line; stdin.byLine){
        Packet data;
		// The 'with' statement allows us to access an object
		// (i.e. member variables and member functions)
		// in a slightly more convenient way
		with (data){
			user = "clientName";
			// Just some 'dummy' data for now
			r = g = b = x = y = 50;
			message = "test";
		}
		// Send the packet of information
        socket.send(data.GetPacket);
		// Now we'll immedietely block and await data from the server
		auto fromServer = buffer[0 .. socket.receive(buffer)];
        writeln("Server echos back: ", fromServer);
		write(">");
    }
}
