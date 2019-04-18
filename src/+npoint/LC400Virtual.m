classdef LC400Virtual < npoint.AbstractLC400
    
    properties (Constant)
        
    end
    
    properties (Access = private)
        
        lEnabled = [false, false]
        lActive = [false, false]
        lServoState = [false, false]
        
        dGainP = [1001, 1002];
        dGainI = [0.1, 0.2];
        dGainD = [10, 20];
        
        dOffsetAnalog = [0, 0]
        dOffsetDigital = [0, 0]
        dOffsetMonitor = [0, 0]
        
        dScaleAnalog = [1, 1]
        dScaleDigital = [1, 1]
        dScaleDigitalInv = [1, 1]
        dScaleMonitor = [1, 1]
        
        i32Wavetable;
        
        
        
    end
    
    methods 
            
        function this = LC400Virtual() 
            
            % Initialize to 5 Hz
            dFreq = 5; % hz
            dTime = 0 : 24e-6 : 2;
            
            this.i32Wavetable(1, :) = int32( 2^20 / 2 * 0.5 * sin(2 * pi * dFreq * dTime));
            this.i32Wavetable(2, :) = int32( 2^20 / 2 * 0.5 * cos(2 * pi * dFreq * dTime));
        end
        
        function delete(this)
            
        end
        
        % @param {uint8 1x1} channel
        % @return {logical 1x1}
        function l = getWavetableEnable(this, u8Ch)
            l = this.lEnabled(u8Ch);
        end
        
        % @param {uint8 1x1} channel
        % @return {logical 1x1}
        function l = getWavetableActive(this, u8Ch)
            l = this.lActive(u8Ch);
        end
        
        % @param {uint8 1x1} u8Ch - channel
        % @param {char 1x1} cProp - PID property. Supported values
        % this.GAIN_PROPORTIONAL
        % this.GAIN_INTEGRAL
        % this.GAIN_DERIVATIVE
        % @return {double 1x1}
        function d = getGain(this, u8Ch, cProp) 
            switch cProp
                case this.GAIN_PROPORTIONAL
                    d = this.dGainP(u8Ch);
                case this.GAIN_INTEGRAL
                    d = this.dGainI(u8Ch);
                case this.GAIN_DERIVATIVE
                    d = this.dGainD(u8Ch);
            end    
        end
        
        % @param {uint8 1x1} channel
        % @return {logical 1x1}
        function l = getServoState(this, u8Ch)
            l = this.lServoState(u8Ch);
        end
        
        % @param {uint8 1x1} channel
        % @param {char 1xm} cProp - supported values:
        % this.ANALOG_SCALE
        % this.DIGITAL_SCALE
        % this.DIGITAL_SCALE_INV
        % this.MONITOR_SCALE
        % @return {double 1x1}
        function d = getFloatValueFromString(this, u8Ch, cProp)
            switch cProp
                case this.ANALOG_SCALE
                    d = this.dScaleAnalog(u8Ch);
                case this.DIGITAL_SCALE
                    d = this.dScaleDigital(u8Ch);
                case this.DIGITAL_SCALE_INV
                    d = this.dScaleDigitalInv(u8Ch);
                case this.MONITOR_SCALE
                    d = this.dScaleMonitor(u8Ch);
            end
        end
        
        % @param {uint8 1x1} channel
        % @param {char 1xm} supported values:
        % this.ANALOG_OFFSET
        % this.DIGITAL_OFFSET
        % this.MONITOR_OFFSET
        % @return {double 1x1}
        function d = getIntValueFromString(this, u8Ch, cProp)
            switch cProp
                case this.ANALOG_OFFSET
                    d = this.dOffsetAnalog(u8Ch)
                case this.DIGITAL_OFFSET
                    d = this.dOffsetDigital(u8Ch)
                case this.MONITOR_OFFSET
                    d = this.dOffsetMonitor(u8Ch)
            end
        end
        
        
        % @param {uint32) u32Num - number of samples @ 24us clock
        % @return {uint32 2 x u32Num} - wavetable values in [-2^19, +2^19]
        function u32 = getWavetables(this, u32Num)
            u32 = this.i32Wavetable(:, 1 : u32Num);
        end
        
        % @param {uint8 1x1} channel
        % @param {char 1x1} supported values
        % this.GAIN_PROPORTIONAL
        % this.GAIN_INTEGRAL
        % this.GAIN_DIFFERENTIAL
        function setGain(this, u8Ch, cProp, dVal)
            switch cProp
                case this.GAIN_PROPORTIONAL
                    this.dGainP(u8Ch) = dVal;
                case this.GAIN_INTEGRAL
                    this.dGainI(u8Ch) = dVal;
                case this.GAIN_DERIVATIVE
                    this.dGainD(u8Ch) = dVal;
            end
        end
                
        % @param {uint8 1x1} channel 
        % @param {int32 1xm} 20-bit values
        function setWavetable(this, u8Ch, i32Vx)
            this.i32Wavetable(u8Ch, 1 : length(i32Vx)) = i32Vx;
        end
        
        % @param {uint8 1x1} channel
        % @param {logical 1x1} 
        function setWavetableEnable(this, u8Ch, l)
            this.lEnabled(u8Ch) = l;
        end
                
        % Enable/disable both channels simultaneously
        % @param {logical 1x1} true to enable
        function setTwoWavetablesActive(this, l)
            this.lActive(1) = l;
            this.lActive(2) = l;
        end
        
        
        % Record ch1 and ch2 command value and sensor value for a specified
        % number of clock cycles.  The clock is 24 us (one sample per 24 us).
        % Max is two seconds worth of data or 83333 samples.
        % @param {uint32) u32Num - number of samples @ 24us clock
        % @return {int32 4 x u32Num} i32Data - output data. Read below
        % for scaling. See record() for data returned in radians
        %
        % Notes
        %
        % i32Data(1, :) - ch 1 command
        % i32Data(2, :) - ch 1 sensor
        % i32Data(3, :) - ch 2 command
        % i32Data(4, :) - ch 2 sensor
        % Range of values is +/- 2^19 iven though data type is i32  
        % +2^19 is +3 mrad mechanical tilt
        % -2^19 is -3 mrad mechanical tilt
        %
        % Need to cast i32 returned from Java as a double before the
        % multiplication because in matlab when you multipley i32 by a
        % double it stays an i32 and since the return will be between
        % -10 and 10 it would only be integers

        % 2013.08.27 adding the digital scale factor, which is the ratio
        % between the open loop range of the stage and the closed loop
        % range.  When you record data from the 'input' register, it
        % needs to be scaled by the inverse of the digital scale factor
        % to convert back to real world units.  The sensor output
        % register already has the inverse digital scale factor applied.
        
        function i32 = recordRaw(this, u32Num)
            i32(1, 1 : u32Num) = this.i32Wavetable(1, 1 : u32Num); % ch1 raw command
            
            if this.lActive(1)
                i32(2, 1 : u32Num) = this.i32Wavetable(1, 1 : u32Num); % ch1 raw sensor
            else
                i32(2, 1 : u32Num) = int32(randn(1, u32Num) * 0.025 * 2^18);
            end
            
            i32(3, 1 : u32Num) = this.i32Wavetable(2, 1 : u32Num); % ch1 raw command
            
            if this.lActive(2)
                i32(4, 1 : u32Num) = this.i32Wavetable(2, 1 : u32Num); % ch2 raw sensor
            else
                i32(4, 1 : u32Num) = int32(randn(1, u32Num) * 0.025 * 2^18); % ch2 raw sensor
            end
            
        end
        
        % See recordRaw().  Difference here is returned values are {double}
        % and are mechanical tilt of stage relative to max value. 
        % @param {uint32) u32Num - number of samples @ 24us clock
        % @return {double 4 x u32Num} dData - relative tilt of stage
        
        function d = record(this, u32Num)
            dRaw = double(this.recordRaw(u32Num)); % in [-2^19, +2^19]
            dRel = dRaw / (2^19); % in [-1, 1]
            d = dRel;
            % d = dRel * 3e-3; % in [-3 mrad, +3 mrad]
        end
        
            
        function u32 = getEndIndexOfWavetable(this, u8Ch)
            u32 = uint32(length(this.i32Wavetable(u8Ch, :)));
        end

            
        
    end
    
end

