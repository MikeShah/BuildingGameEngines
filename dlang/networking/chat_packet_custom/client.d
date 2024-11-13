import std.socket;
import std.stdio;
import std.conv;

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
    socket.connect(new InternetAddress("localhost", 50002));
	scope(exit) socket.close();
	writeln("Connected");

    // Buffer of data to send out
    byte[Packet.sizeof] buffer;
    auto received = socket.receive(buffer);

    writeln("On Connect: ", buffer[0 .. received]);
	write(">");
    foreach(line; stdin.byLine){
        Packet data;
		// The 'with' statement allows us to access an object
		// (i.e. member variables and member functions)
		// in a slightly more convenient way
		with (data){
			user = "clientName\0";
			// Just some 'dummy' data for now
			// that the 'client' will continuously send
			x = 7;
			y = 5;
			r = 49;
			g = 50;
			b = 51;
			message = "test\0";
		}
		// Send the packet of information
        socket.send(data.GetPacketAsBytes());
		// Now we'll immedietely block and await data from the server
		// Shows you some useful debug information
		auto fromServer = buffer[0 .. socket.receive(buffer)];
		writeln("sizeof fromServer:",fromServer.length);
		writeln("sizeof Packet    :", Packet.sizeof);
		writeln("buffer length    :", buffer.length);
		writeln("fromServer (raw bytes): ",fromServer);
		writeln();


		// Format the packet. Note, I am doing this in a very
		// verbosoe manner so you can see each step.
		Packet formattedPacket;
		byte[16] field0        = fromServer[0 .. 16].dup;
		formattedPacket.user = cast(char[])(field0);
        writeln("Server echos back user: ", formattedPacket.user);

		// Get some of the fields
		byte[4] field1        = fromServer[16 .. 20].dup;
		byte[4] field2        = fromServer[20 .. 24].dup;
		int f1 = *cast(int*)&field1;
		int f2 = *cast(int*)&field2;
		formattedPacket.x = f1;
		formattedPacket.y = f2;

		writeln("what is field1(x): ",formattedPacket.x);
		writeln("what is field2(y): ",formattedPacket.y);
		// NOTE: You may want to explore std.bitmanip, if you
		//       have different endian machines.
//		int value = peek!(int,Endian.littleEndian)(field1);

		write(">");
    }
}
