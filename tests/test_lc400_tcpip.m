[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Src
addpath(genpath(fullfile(cDirThis, '..', 'src')));

% Dependencies
cDirVendor = fullfile(cDirThis, '..', 'vendor');

% github/cnanders/matlab-hex
addpath(genpath(fullfile(cDirVendor, 'github', 'cnanders', 'matlab-hex', 'src')));

% github/cnanders/matlab-ieee
addpath(genpath(fullfile(cDirVendor, 'github', 'cnanders', 'matlab-ieee', 'src')));

lc400 = npoint.lc400.LC400(...
    'cConnection', npoint.lc400.LC400.cCONNECTION_TCPIP, ...
    'cTcpipHost', '192.168.0.3', ...
    'u16TcpipPort', 23 ...
);


lc400.init();
lc400.connect();
% lc400.s.BaudRate
% lc400.s.Terminator
lc400.getRange(1)

% Test
cAddress = hex.HexUtils.add(lc400.addrCh1Base, lc400.offsetRange);
lc400.readSingle([cAddress; cAddress], ['uint32'; 'uint32'])

lc400.disconnect()
return;

d = lc400.getWavetables(30000);
figure
hold on
plot(d(1, :), 'r');
plot(d(2, :), 'b');
legend({'ch 1', 'ch 2'});

lc400.disconnect();
return;

%{
lc400.setTwoWavetablesActive(false);

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

lc400.setWavetable(uint8(1), xInt');
lc400.setWavetable(uint8(2), yInt');

%}

w = lc400.getWavetables(20000);

figure
% subplot(122)
hold on
plot(w(1, :), 'r')
plot(w(2, :), 'b')

return


lc400.setWavetableEnable(1, true);
lc400.setWavetableEnable(2, true);
lc400.setTwoWavetablesActive(true);

% (uint32(length(t))

d = lc400.recordRaw(5000);
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

lc400.setTwoWavetablesActive(false);




