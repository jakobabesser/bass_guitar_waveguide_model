function [ Y_interp ] = LinInterpol( X_target, Y1, Y2 )
% This function interpolates a value between Y1 and Y2 for a fractional
% Number X_target between 0 and 1.
% 
% REFERENCES:
%
% INPUT:
%       X_target:       fractional number between 0 and 1
%       Y1:             y-value number one
%       Y2:             y-value number two
% OUTPUT:
%       Y_interp:       interpolated value between Y1 and Y2
%
% FUNCTION CALLS:
%


%% difference between Y2 and Y1
Y_diff = Y2 - Y1;

%% linear interpolating value between Y1 and Y2
Y_interp = Y1 + X_target*Y_diff;

%% plotting the values
% plot(1, Y1,'o', 2, Y2,'o', X_diff+1, Y_interp,'x');

end