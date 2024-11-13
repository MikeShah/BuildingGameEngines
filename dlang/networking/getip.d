// @file getip.d
import std.stdio;
import std.range;
import std.socket;

// NOTE: Error checking code omitted.
//       Likely should put this in a try/catch/finally block
//       and handle SocketException.
//       Can also check if 'r' is empty.
void GetIP(){
    // A bit of a hack, but we'll create a connection from google to
    // our current ip.
    // Use a well known port (i.e. google) to do this
    auto r = getAddress("8.8.8.8",53); // NOTE: This is effetively getAddressInfo
    // writeln(r); // See 1 or more 'ips'
    // Create a socket
    auto sockfd = new Socket(AddressFamily.INET,  SocketType.STREAM);
    // Connect to the google server
    import std.conv;
    const char[] address = r[0].toAddrString().dup;
    ushort port = to!ushort(r[0].toPortString());
    sockfd.connect(new InternetAddress(address,port));
    // Obtain local sockets name and address
    writeln(sockfd.hostName);
    writeln("Our ip address    : ",sockfd.localAddress);
    writeln("the remote address: ",sockfd.remoteAddress);

    // Close our socket
    sockfd.close();
}



void main(){

    // Retrieve our IP
    GetIP();

    writeln('='.repeat(30));
    // Retrieve our host name
    writeln("hostname: ",Socket.hostName);

    writeln('='.repeat(30));
    // Retrieve information about your machine
    // Your system otherwise may have multiple ips.
    auto results = getAddress(Socket.hostName);
    foreach(addr ; results){
        writeln("address family: ",addr.addressFamily);
        writeln("name    : ",addr.name);
        writeln("address : ",addr.toAddrString());
        writeln("HostName: ",addr.toHostNameString());
        writeln("Port    : ",addr.toPortString());
        writeln("Service : ",addr.toServiceNameString());
        writeln();
    }

}
