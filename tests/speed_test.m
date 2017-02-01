[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));


% Add iee package
addpath(genpath(fullfile(cDirThis, 'pkgs', 'ieee')));


clc


num = 10^4;
cHex = repmat('A1', num, 2);
dNum = ones(num, 1) * 100;

% Call hex2dec on each row of cHex
tic
for n = 1:num
    d = hex2dec(cHex(n, :));
end
dElapsedTime = toc;

fprintf(...
    '%1.3f sec to call hex2dec in loop %1.0f times\n', ...
    dElapsedTime, ...
    num ...
);

% Call it once on the entire cHex
tic
d = hex2dec(cHex);
dElapsedTime = toc;
fprintf(...
    '%1.3f sec to call hex2dec once on entire matrix\n', ...
    dElapsedTime ...
);

%{
tic
c = dec2hex(dNum);
toc

%}



% Call it once on the entire cHex

tic
for n = 1:num
    d = ieee.Utils.hex2bin(cHex(n, :));
end
dElapsedTime = toc;
fprintf(...
    '%1.3f sec to call ieee.Utils.hex2bin in loop %1.0f times\n', ...
    dElapsedTime, ...
    num ...
)

tic
bin = ieee.Utils.hex2bin(cHex);
dElapsedTime = toc;
fprintf(...
    '%1.3f sec to call ieee.Utils.hex2bin once on entire matrix\n', ...
    dElapsedTime ...
);



