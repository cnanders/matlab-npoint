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
        
        
    end
    
end

