# 1.0.2

- Added support for tcpip connection protocol.  To use tcpip connection, set `cConnection` property to `noint.lc400.LC400.cCONNECTION_TCPIP` with varargin syntax and set `cTcpipHost` to the IP address using varargin syntax.  The LC400 uses telnet port 23 for network communication.  The `u16TcipiPort` property defaults to 23 and will most likeley never need to be set (but it can be set with varargin syntax, if necessary).

# 1.0.1

- Moved /pkg to /src