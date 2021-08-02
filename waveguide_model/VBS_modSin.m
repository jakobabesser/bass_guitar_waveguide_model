function [ f_change, freq2 ] = VBS_modSin( expr_style, freq1, cent, time, fs, f_vib )
% This function creates a frequency curve for vibrato, bending and slide
% effects given the start frequency and cent difference (and vibrato
% frequency) based on a sine function.
% 
% REFERENCES:
%
% INPUT:
%       expr_style:    	expression style
%       freq1:          start frequency (Hz)
%       cent:           difference in cent
%       time:           duration (s)
%       fs:             fundamental frequency (Hz)
%       f_vib:          vibrato frequency (Hz)
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

%% creating time samples
t = (1:1:fs*time);

%% getting vibration frequency
if strcmp(expr_style, 'VI') == 1
    f = f_vib/fs;
else
    freq = 1/time;
    f = freq/fs;
end
f = f_vib/fs;

%% dimming curve for sinus
if strcmp(expr_style, 'VI') == 1
    dim = linspace(1,0.85,fs*time);
else
    dim = 2;
end

%% calculating frequency changing curve
f_changeInit = dim.*freq_diff.*(0.5*sin(2*pi*t*f+(-pi/2))+0.5);
f_changeInit(f_changeInit>freq_diff) = freq_diff;
wL = round(fs/4);
wind = hann(wL)/sum(hann(wL));
f_change = conv2(f_changeInit, wind');
f_change = f_change(1:round(fs*time));
end