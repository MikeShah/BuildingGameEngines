// @file Packet.d


// NOTE: Consider the endianness of the target machine when you 
//       send packets. If you are sending packets to different
//       operating systems with different hardware, the
//       bytes may be flipped!
//       A test you can do is to when you send a packet to a
//       operating system is send a 'known' value to the operating system
//       i.e. some number. If that number is expected (e.g. 12345678), then
//       the byte order need not be flipped.
struct Packet{
	// NOTE: Packets usually consist of a 'header'
	//   	 that otherwise tells us some information
	//  	 about the packet. Maybe the first byte
	// 	 	 indicates the format of the information.
	// 		 Maybe the next byte(s) indicate the length
	// 		 of the message. This way the server and
	// 		 client know how much information to work
	// 		 with.
	// For this example, I have a 'fixed-size' Packet
	// for simplicity -- effectively cramming every
	// piece of information I can think of.

	char[16] user;  // Perhaps a unique identifier 
    uint x;
    uint y;
    ubyte r;
    ubyte g;
    ubyte b;
    char[64] message; // for debugging

    char[Packet.sizeof] GetPacket(){
        message = "message";
        char[Packet.sizeof] payload;
        return payload;
    }

	
}
