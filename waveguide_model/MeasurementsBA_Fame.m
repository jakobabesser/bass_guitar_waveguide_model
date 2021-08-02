function out = MeasurementsBA_Fame()
% Measurements of the electric bass.  
%
% REFERENCES:
%
% INPUT:
%       Scale:          scale length
% 
% OUTPUT:
%       FretPos:        fret positions
%
% FUNCTION CALLS:
%


%% setting up plucking positions in % of string length
out.FingerPluckPos = 17;% +((rand-rand));
out.PickPluckPos = 8;% +((rand-rand));
out.DampPluckPos = 12;% +(rand-rand);
out.slapPluckPos = 30;% +((rand-rand)*3);
out.slapPos = 33;% +((rand-rand)*3);
out.slapWidth = 35; % 30

%% setting up pickup positions
out.PickupPosB=6.3364; %8.2176; 
out.PickupPosN=14.0553; %18.6343;  
