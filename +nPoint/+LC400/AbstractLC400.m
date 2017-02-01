classdef AbstractLC400 < handle
    
    properties (Constant)
        
       % {char 1xm} - The ratio between the open loop range of the stage
       % and the closed loop range.
       DIGITAL_SCALE_INV = 'digital_scale_inv' 
       
       DIGITAL_SCALE = 'digital_scale';
       ANALOG_SCALE = 'analog_scale';
       MONITOR_SCALE = 'monitor_scale';
       
       ANALOG_OFFSET = 'analog_offset';
       DIGITAL_OFFSET = 'digital_offset';
       MONITOR_OFFSET = 'monitor_offset';
       
       GAIN_PROPORTIONAL = 'PROPORTIONAL';
       GAIN_INTEGRAL = 'INTEGRAL';
       GAIN_DERIVATIVE = 'DERIVATIVE';
        
        
    end
    
    methods (Abstract)
        
        
        
        % @param {uint8 1x1} channel
        % @return {logical 1x1}
        getWavetableEnable(this, u8Ch)
        
        % @param {uint8 1x1} channel
        % @return {logical 1x1}
        getWavetableActive(this, u8Ch)
        
        % @param {uint8 1x1} u8Ch - channel
        % @param {char 1x1} cProp - PID property. Supported values
        % this.GAIN_PROPORTIONAL
        % this.GAIN_INTEGRAL
        % this.GAIN_DIFFERENTIAL
        % @return {double 1x1}
        getGain(this, u8Ch, cProp) 
        
        % @param {uint8 1x1} channel
        % @return {logical 1x1}
        getServoState(this, u8Ch)
        
        % @param {uint8 1x1} channel
        % @param {char 1xm} cProp - supported values:
        % this.ANALOG_SCALE
        % this.DIGITAL_SCALE
        % this.DIGITAL_SCALE_INV
        % this.MONITOR_SCALE
        % @return {double 1x1}
        getFloatValueFromString(this, u8Ch, cProp)
        
        
        % @param {uint8 1x1} channel
        % @param {char 1xm} supported values:
        % this.ANALOG_OFFSET
        % this.DIGITAL_OFFSET
        % this.MONITOR_OFFSET
        % @return {double 1x1}
        getIntValueFromString(this, u8Ch, cProp)
        
        % @param {uint8 1x1} channel
        % @param {char 1x1} supported values
        % this.GAIN_PROPORTIONAL
        % this.GAIN_INTEGRAL
        % this.GAIN_DIFFERENTIAL
        setGain(this, u8Ch, cProp, dVal)
        
        % @param {uint8 1x1} channel 
        % @param {int32 1xm} 20-bit values
        setWavetable(this, u8Ch, i32Vx)
        
        % @param {uint8 1x1} channel
        % @param {logical 1x1} 
        setWavetableEnable(this, u8Ch, l)
                
        % Enable/disable both channels simultaneously
        % @param {logical 1x1} true to enable
        setTwoWavetablesActive(this, l)   
        
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
        % Range of values is +/- 2^20/2 iven though data type is i32  
        % +2^20/2 is +3 mrad mechanical tilt
        % -2^20/2 is -3 mrad mechanical tilt
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
        recordRaw(this, u32Num)
        
        % See recordRaw().  Difference here is returned values are {double}
        % and are mechanical tilt of stage in radians. 
        % @param {uint32) u32Num - number of samples @ 24us clock
        % @return {double 4 x u32Num} dData - tilt of stage in radians
        
        record(this, u32Num)
        
        
    end
    
end

