function [ f_change, freq2 ] = VBS_Sin( expr_style, freq1, cent, time, fs, f_vib )
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

%% setting "strech factor" of sinus
if strcmp(expr_style, 'SL') == 1
    b = 0.5;
else
    b = 1;
end

%% dimming curve for sinus
if strcmp(expr_style, 'VI') == 1
    dim = linspace(1,0.85,fs*time);
else
    dim = 1;
end

%% calculating frequency changing curve
f_change = dim.*freq_diff.*(0.5*sin(b*2*pi*t*f+(-pi/2))+0.5);

end