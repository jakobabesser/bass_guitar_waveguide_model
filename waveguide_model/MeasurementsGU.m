function out = MeasurementsGU()
% Measurements of the guitar. Taken from an electric guitar.
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



%%Mensur 650mm
%%Pickup1 50mm
%%Pickup2 155mm

%% setting up plucking positions in % of string length
out.FingerPluckPos = 17 +((rand-rand));
out.PickPluckPos = 12 +((rand-rand));
out.DampPluckPos = 12 +(rand-rand);
out.slapPluckPos = 30 +((rand-rand)*3);
out.slapPos = 33 +((rand-rand)*3);
out.slapWidth = 35; % 30

%% setting up pickup positions
out.PickupPosB=7.69; 
out.PickupPosN=23.85; 
