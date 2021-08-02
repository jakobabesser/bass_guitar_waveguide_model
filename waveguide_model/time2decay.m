function [ g ] = time2decay( f0, fs, t60 )
% This function calculates a gain factor for a given fundamental frequency
% and t60 decay time.
% 
% REFERENCES:
%
% INPUT:
%       f0:          	fundamental frequncy (Hz)
%       fs:             sampling frequnecy (Hz)
%       t60:            t60 decay time
%
% OUTPUT:
%       g:              resulting gain factor
%
% FUNCTION CALLS:
%


%% calculating total string loop delay
N = fs/f0;

%% calculating tau
tau = t60/log(1000);

%% calculating time for one sample
T = 1/fs;

%% calcualting gain factor
g = exp(-(N*T)/tau);

end

