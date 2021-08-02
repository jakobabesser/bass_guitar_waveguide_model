function [ f_change, freq2 ] = Slide_Lin( freq1, cent, time, fs )
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


%% getting target frequency
freq2 = cent2freq_WGSynth(freq1, cent);

%% calculating frequncy difference
freq_diff = freq2 - freq1;

%% calculating frequency changing curve
f_change = linspace(0, freq_diff, time*fs);

end