classdef IeeeUtils
    
    % Helper functions to convert to and from IEEE.754 64-bit and 32-bit
    % hexadecimal strings and floating point numbers
    %
    % !! BE ADVISED The IEEE.754 standard is a special format !!
    % https://en.wikipedia.org/wiki/Double-precision_floating-point_format
    % https://en.wikipedia.org/wiki/Single-precision_floating-point_format
    % 
    % The hex string does not correspond to the standard big endian
    % hex you would assume based on the base10 number. 
    %
    % For example,
    %
    % 1     != 0x00000001 (32-bit hex)
    % 10    != 0x0000000A (32-bit hex)
    % 254   != 0x000000FE (32-bit hex)
    %
    % The bits of a IEEE hex string have special meaning.  Step 1 is to
    % convert the hex string into its binary equivalent then starting on
    % the left group the bits in to sign/exponent/fraction blocks. 
    %
    % For 32-bit IEEE.754 format:
    %   bit     1       (1-bit)     === sign
    %   bits    2-9     (8-bit)     === exponent
    %   bits    10-32   (23-bit)    === fraction
    % Decimal value is sign * (1 + fraction/2^23) * 2^(exponent-127)
    %
    % For 64-bit IEEE.754 format:
    %   bit     1       (1-bit)     === sign
    %   bits    2-12    (11-bit)    === exponent
    %   bits    13-64   (52-bit)    === fraction  
    % Decimal value is sign * (1 + fraction/2^52) * 2^(exponent - 1023)
    %
    % Example (32-bit)
    % binary: 1 00000011 00000000000000000001011 (spaces to separate parts)
    % sign = -1 (if first bit is 1, sign is negative)
    % exponent = bin2dec('00000011') = 3
    % fraction = bin2dec('00000000000000000001011') = 11
    % value = -1 * (1 + 11/2^23)*2^-124 = -4.7020e-38
    % The hexadecimal value is '8180000B'
    %
    % Example (32-bit)
    % binary: 0 01111111 00000000000000000000000
    % sign = 1
    % exponent = bin2dec('01111111') = 127
    % fraction = bin2dec('00000000000000000000000') = 0;
    % value = 1 * (1 + 0/2^23) * 2^(127 - 127) = 1
    % Hex equivalent of '00111111100000000000000000000000' is '3F800000',
    % Verified this is correct with wikipedia 
    %
    % MATLAB's built-in hex2num and num2hex convert between a 64-bit
    % IEEE.754 16-char hex and a decimal value (double).  Need to
    % build our own for 32-bit IEEE.754 hexadecimal strings, which ha

        
    % These methods were coded largely by Adam Frost from nPoint
    
    % In MATLAB's internal methods
    % num === float
    % dec === int
    

    properties (Constant)
        
           
        
    end
    
    
    methods (Static)
        
        % Convert 16-character IEEE 64-bit double precision hex string to
        % double-precision number.  
        
        function d = hex64ToNum(c)
            % Use MATLAB' built-in function
            d = hex2num(c);
        end
        
        
        
        % @param {char mx8} x - 8-character hex string in IEEE.754 32-bit
        % format
        % @return {double 1x1} y - single-precision floatint point
        
        function y = hex32ToNum(x)
            
            y = npoint.ieee.IeeeUtils.hex32ToNumMulti(x);
            return;
            
            % x: 32bit hex string
            % y: floating point value

            % unpack the bits
            b = npoint.ieee.IeeeUtils.hex2bin(x);
            s = b(1);
            e = b(2:9);
            f = b(10:32);

            if (e == '00000000')
                y = 0;
            else
                ex = bin2dec(e) - 127;
                f = ['1' f];
                y = (-1)^s * 2^(ex) * bin2dec(f)/2^23;
            end
        end
        
        % Version of hex32ToNum that works on 
        
        % @param {char mx8} x - 8-character hex string in IEEE.754 32-bit
        % format
        % @return {double mx1} y - single-precision floatint point
        function y = hex32ToNumMulti(x)
            
            b = npoint.ieee.IeeeUtils.hex2bin(x);
           
            % sign, exponent, fraction
            s = b(:, 1);
            e = b(:, 2:9);
            f = b(:, 10:32);
           
            y = (-1).^s .* 2.^(bin2dec(e) - 127) .* (1 + bin2dec(f)./2^23);
           
        end

        % Convert singles and doubles to IEEE.754 64-bit hexadecimal
        % string (16-character).  Be advised of IEEE format. 
        % @param {double 1x1} d - the number you want to convert
        % @return {char 1x16} c - IEEE.754 64-bit hex string
        function c = numToHex64(d)
            
            % Use MATLAB's built-in support
            c = num2hex(d);
            
        end
        
        
        % Convert singles and doubles to IEEE.754 32-bit hexadecimal
        % string (8-character).  Be advised of IEEE format. 
        % @param {double 1x1} x - the number you want to convert
        % @return {char 1x8} y - IEEE.754 32-bit hex string
        
        function cIeee32Hex = numToHex32(x)
            
                        
            % Going to switch to using numToHex32Multi but preserving this
            % old function for historical purposes (I think it is a little
            % easier to read the single
            
            cIeee32Hex = npoint.ieee.IeeeUtils.numToHex32Multi(x);
            return;
                        

            % easier to convert to the 64bit version then back to the 32bit version
            % rather than construct the whole thing from scratch.
            
            % Get 64-bit hex using built-in MATLAB
            cIeee64Hex = npoint.ieee.IeeeUtils.numToHex64(x);
            

            % Convert to binary, extract 64-bit sign, exponent, fraction
            % (one for each row / value)
            cIeee64Bin = npoint.ieee.IeeeUtils.hex2bin(cIeee64Hex);
            cIeee64SignBin = cIeee64Bin(1);
            cIeee64ExpBin = cIeee64Bin(2:12);
            cIeee64FracBin = cIeee64Bin(13:64);

            if (x == 0)
                cIeee32SignBin = '0';
                cIeee32ExpBin = '00000000';
                cIeee32FracBin = '00000000000000000000000';
            else
                
                % Sign stays the same
                cIeee32SignBin = cIeee64SignBin; 
                
                % Denormalize the exponent.
                %
                % First step is to convert the 11-bit exponent of the
                % IEEE.754 64-bit format into its integer representation.
                %
                % Then the 64-bit version 2^(iIeee64ExpInt - 1023)
                % needs to 32-bit version 2^(iIeee32ExpInt - 127)
                % Solving for iIeee32ExpInt gives:
                % 
                % iIeee32ExpInt = iIeee64ExpInt - 1023 + 127.  Then you can convert
                % iIeee32ExpInt into its 8-bit binary equivalent representation
                
                iIeee64ExpInt = bin2dec(cIeee64ExpBin);
                iIeee32ExpInt = iIeee64ExpInt - 1023 + 127;
               
                % Convert from integer to 8-bit binary representation
                cIeee32ExpBin = dec2bin(iIeee32ExpInt, 8);
                
                % Truncate the fraction 
                cIeee32FracBin = cIeee64FracBin(1:23);
            end
            
            % Assemble IEEE.754 32-bit binary representation
            cIeee32Bin = [cIeee32SignBin cIeee32ExpBin cIeee32FracBin];
            cIeee32Hex = npoint.ieee.IeeeUtils.bin2hex(cIeee32Bin, 8);
            
        end
        
        % @param {double nx1} x - input 32-bit single-precision floating
        % point numbers
        function cIeee32Hex = numToHex32Multi(x)
            
            
            % Easier to convert to the 64bit version then back to the 32bit version
            % rather than construct the whole thing from scratch.
            
            % Get 64-bit hex using built-in MATLAB
            cIeee64Hex = npoint.ieee.IeeeUtils.numToHex64(x);
            
            % Convert to binary, extract 64-bit sign, exponent, fraction
            % (one for each row / value)
            
            cIeee64Bin = npoint.ieee.IeeeUtils.hex2bin(cIeee64Hex);
            cIeee64SignBin = cIeee64Bin(:, 1);
            cIeee64ExpBin = cIeee64Bin(:, 2:12);
            cIeee64FracBin = cIeee64Bin(:, 13:64);
            
            % s32 = repmat('0', rows, 1); 
            % e32 = repmat('0', rows, 8); % 8-bits for IEEE.754 32-bit exponent
            % f32 = repmat('0', rows, 23); % 23-bits for IEEE.754 32-bit fraction
            
            
            % Denormalize the exponent from 64-bit format to 32-bit format.
            % Three-step process described below
            
            % Step 1
            % Convert 11-bit exponent of 64-bit format to integer representation
            iIeee64ExpInt = bin2dec(cIeee64ExpBin);
            
            % Step 2
            % Equating exponent multipliers of the 64-bit and 32-bit
            % IEEE.754 formats
            % 2^(iIeee64ExpInt - 1023) === 2^(iIeee32ExpInt - 127)
            % then solve for iIeee32ExpInt
            
            iIeee32ExpInt = iIeee64ExpInt - 1023 + 127;
            
            % Step 3
            % Convert to 8-bit binary representation for 32-bit IEEE.754 format
            % but only where x is nonzero
            
            % Initialize cIeee32ExpBin 
            [rows, cols] = size(x);
            cIeee32ExpBin = repmat('0', rows, 8); % 8-bits for IEEE.754 32-bit exponent
            
            idx = find(x ~= 0);
            if ~isempty(idx)
                cIeee32ExpBin(idx, :) = dec2bin(iIeee32ExpInt(idx), 8);
            end
            
            
            % Truncate the fraction to the first 23 bits.  Still not sure
            % why we use elements 1:23 and not (end - 23:end) 
            cIeee32FracBin = cIeee64FracBin(:, 1:23);
            
            % Assemble IEEE.754 32-bit binary representation
            cIeee32Bin = [cIeee64SignBin cIeee32ExpBin cIeee32FracBin];
            
            % Convert to hex
            cIeee32Hex = npoint.ieee.IeeeUtils.bin2hex(cIeee32Bin, 8);
            
            
        end

        
        % Convert a hex string to a binary string representation
        % @param {char 1xm} cHex - m-character hex string (big endian)
        % @param {int8 1x1} [i8Bits = m*4] - the number of bits in the output
        % @param {char 1xi8Bits} y - binary string (big endian)
        
        function y = hex2bin(c, i8Bits)
            
            if nargin == 1
                i8Bits = length(c) * 4;
            end
                        
            % Convert from hex representation to integer representation
            yInt = hex2dec(c);
            % Convert from integer representation to binary representation,
            % forcing 
            y = dec2bin(yInt, i8Bits);
        end
        
        % Convert a binary string to a hex string.  
        % @param {char 1xm} x - binary string (big endian)
        % @param {int8 1x1} [i8Num = length(c)] - the number of hex characters in the output
        
        function cHex = bin2hex(cBin, i8Num)
            
            if nargin == 1
                i8Num = ceil(length(cBin)/4);
            end
            iVal = bin2dec(cBin);
            cHex = dec2hex(iVal, i8Num);
        end
        
        
    end
    
end
