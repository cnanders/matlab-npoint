classdef HexUtils
    
    % Helper functions to convert to and from hex strings encoded with
    % the IEEE.754 32 bit floating point
    % format.  The bin2dec, dec2bin and num2hex are built-in Matlab
    % functions, the others are listed here...
    %
    % These methods were coded by Adam Frost from nPoint

        
    properties (Constant)
        
        
    end
    
    
    methods (Static)
        
         
        % Add two big endian hex strings and return the sum as a big endian
        % hex string
        % @param {char 1xm} m-character big endian hex string
        % @param {char 1xn} n-character big endian hex string
        % @return {char 1x?} big endian hex string
        function c = add(c1, c2)
            c = dec2hex(hex2dec(c1) + hex2dec(c2));
        end
        
        % @param 8-character 32-big hex string
        function c = changeEndianness32(c)
            c = c([7 8 5 6 3 4 1 2]);
        end
        
        % Convet big endian hex string to base10 integer representation
        % @param {char 1xm} m-character big endian hex string
        function i = hex32ToInt(c)
            i = hex2dec(c); 
            % i = typecast(uint32(sscanf(c, '%x')), 'int32');
        end
        
        % Convert a {int8} into a two-character hex string.  Works for an
        % array of {int8} as well
        function c = int8ToHex(i8)
            c = sprintf('%02x', i8);            
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

