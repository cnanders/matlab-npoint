
[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Add this pkg
addpath(genpath(fullfile(cDirThis, '..', 'src')));

lc400 = npoint.LC400Virtual();
w = lc400.getWavetables(20000);

figure
hold on
plot(w(1, :), 'r')
plot(w(2, :), 'b')


lc400.setWavetableEnable(1, true);
lc400.setWavetableEnable(2, true);
lc400.setTwoWavetablesActive(true);

d = lc400.recordRaw(10000);
figure
hold on
plot(d(1, :), 'rx');
plot(d(2, :), 'b');
plot(d(3, :), 'go');
plot(d(4, :), 'y');
legend({...
    'ch 1 cmd', ...
    'ch 1 sensor', ...
    'ch 2 cmd', ...
    'ch 2 sensor' ...
});

lc400.setTwoWavetablesActive(false);

% Set to 100 Hz
dFreq = 100; % hz
dTime = 0 : 24e-6 : 2;

i32X = int32( 2^20 / 2 * sin(2 * pi * dFreq * dTime));
i32Y = int32( 2^20 / 2 * cos(2 * pi * dFreq * dTime));


lc400.setWavetable(uint8(1), i32X);
lc400.setWavetable(uint8(2), i32Y);


w = lc400.getWavetables(round(0.5/24e-6));

figure
hold on
plot(w(1, :), 'r')
plot(w(2, :), 'b')

