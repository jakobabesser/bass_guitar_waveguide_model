function [ f_change, freq2 ] = SlideFunction( freq1, cent, time, fs )
% This function creates a linear frequency curve for sliding effects
% given the start frequency and cent difference.
% 
% REFERENCES:
%
% INPUT:
%       freq1:          start frequency (Hz)
%       cent:           difference in cent
%       time:           duration (s)
%       fs:             fundamental frequency (Hz)
%
% OUTPUT:
%       f_change:    	resulting frequency curve
%       freq2:          target frequency
%
% FUNCTION CALLS:
%


%% defining slide time in s
SLTime = 0.1;

%% getting target frequency
freq2 = cent2freq_WGSynth(freq1, cent);

%% calculating frequncy difference
freq_diff = freq2 - freq1;

%% calculating timeSamples
SLTimeSample = floor(SLTime*fs);
timeSample = floor(time*fs);
timeSampleWithoutSL = timeSample-SLTimeSample;
if timeSampleWithoutSL >= 2
    timeSampleBegin = floor(timeSampleWithoutSL/2);
    timeSampleEnd = ceil(timeSampleWithoutSL/2);
else
    SLTime = time;
end

%% calculating frequency changing curve
startFunction = linspace(0, 0, timeSampleBegin);
endFunction = linspace(freq_diff, freq_diff, timeSampleEnd);
if timeSampleWithoutSL >= 2
    f_change = [startFunction, VBS_Sin( 'SL', freq1, cent, SLTime, fs, 0 ), endFunction];
else
    f_change = VBS_Sin( 'SL', freq1, cent, SLTime, fs, 0 );
end
end