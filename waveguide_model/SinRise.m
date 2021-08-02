function [ sin_rise, time ] = SinRise( freq, heigth, fs )
% This function creates the rise of a sine.
%
% REFERENCES:
%
% INPUT:
%       freq:          	frequency of sinus (Hz)
%       heigth:         height of the rise
%       fs:             sampling frequency (Hz)
%
% OUTPUT:
%       sin_rise:      	resulting rise of sinus
%       time:           duration of the rise
%
% FUNCTION CALLS:
%


%% calculating sinus frequency
f = freq/fs;

%% calculating end time of sinus rise
time = 1/freq/4;

%% creating time samples
t = (1:1:fs*time);

%% setting up sinus parameters
c = -pi/2;
b = 2;

%% calculating rise of sinus
sin_rise = heigth.*(0.5*sin(b*2*pi*t*f+c)+0.5);

end