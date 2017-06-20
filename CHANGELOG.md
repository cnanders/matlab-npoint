# 1.0.4

- Fixed bug in 1.0.3 where `InputBuffer` and `OutputBuffer` properties of `tcpclient` were being accessed

# 1.0.3

- Added support for `tcpclient` (an alternative to `tcpip` that does not require the instrument control toolbox).  To use `tcpclient`, set `cConnection` property to `noint.lc400.LC400.cCONNECTION_TCPCLIENT` with varargin syntax
- `tcpclient` requires passing `int8` data to `write()` 

# 1.0.2

- Added support for tcpip connection protocol.  To use tcpip connection, set `cConnection` property to `noint.lc400.LC400.cCONNECTION_TCPIP` with varargin syntax and set `cTcpipHost` to the IP address using varargin syntax.  The LC400 uses telnet port 23 for network communication.  The `u16TcipiPort` property defaults to 23 and will most likeley never need to be set (but it can be set with varargin syntax, if necessary).

# 1.0.1

- Moved /pkg to /src