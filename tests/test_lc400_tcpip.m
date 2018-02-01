[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Src
addpath(genpath(fullfile(cDirThis, '..', 'src')));

% Dependencies
cDirVendor = fullfile(cDirThis, '..', 'vendor');

% github/cnanders/matlab-hex
addpath(genpath(fullfile(cDirVendor, 'github', 'cnanders', 'matlab-hex', 'src')));

% github/cnanders/matlab-ieee
addpath(genpath(fullfile(cDirVendor, 'github', 'cnanders', 'matlab-ieee', 'src')));

comm = npoint.LC400(...
    'cConnection', npoint.LC400.cCONNECTION_TCPCLIENT, ...
    'cTcpipHost', '192.168.20.20', ...
    'u16TcpipPort', 23 ...
);


comm.init();
comm.connect();
% comm.s.BaudRate
% comm.s.Terminator
comm.getRange(1)
comm.getWavetableActive(1)
comm.getWavetableActive(2)

%{
comm.disconnect()
return;
%}


% Test
cAddress = hex.HexUtils.add(comm.addrCh1Base, comm.offsetRange);
comm.readSingle([cAddress; cAddress], ['uint32'; 'uint32'])

comm.disconnect()

return;

d = comm.getWavetables(30000);
figure
hold on
plot(d(1, :), 'r');
plot(d(2, :), 'b');
legend({'ch 1', 'ch 2'});

comm.disconnect();
return;

%{
comm.setTwoWavetablesActive(false);

period = 50e-3;
clock = 24e-6;
t = 0: clock : period;
f = 1/period;
a = 0.1;
x = a * sin(2 * pi * t * f);
y = a * cos(2 * pi * t * f);

% Bin to 20-bit [-524287 : +524287]

xInt = int32(x * (2^20 - 2) / 2);
yInt = int32(y * (2^20 - 2) / 2);


figure
subplot(121)
hold on
plot(t, xInt, 'r')
plot(t, yInt, 'b');

comm.setWavetable(uint8(1), xInt');
comm.setWavetable(uint8(2), yInt');

%}

w = comm.getWavetables(20000);

figure
% subplot(122)
hold on
plot(w(1, :), 'r')
plot(w(2, :), 'b')

return


comm.setWavetableEnable(1, true);
comm.setWavetableEnable(2, true);
comm.setTwoWavetablesActive(true);

% (uint32(length(t))

d = comm.recordRaw(5000);
figure
hold on
plot(d(1, :), 'r');
plot(d(2, :), 'b');
plot(d(3, :), 'g');
plot(d(4, :), 'y');
legend({...
    'ch 1 cmd', ...
    'ch 1 sensor', ...
    'ch 2 cmd', ...
    'ch 2 sensor' ...
});

comm.setTwoWavetablesActive(false);




