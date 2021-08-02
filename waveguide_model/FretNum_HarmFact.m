function [ Harm_Factor, Harm ] = FretNum_HarmFact( Fret_Number )
% This function delivers the nearest harmonics factor to a given fret
% number.
% 
% REFERENCES:
%
% INPUT:
%       Fret_Number:          	bass guitar fret number (1-20)
%
% OUTPUT:
%       Harm_Factor:            harmonic faktor
%       Harm:                   harmonic number (or also "2" for no real
%                               harmonic positions)
%
% FUNCTION CALLS:

%% getting harmonic factor to fret number
switch (Fret_Number)
    case (1)
        Harm_Factor = 15/16;
        Harm = 16;
    case (2)
        Harm_Factor = 8/9;
        Harm = 9;
    case (3)
        Harm_Factor = 5/6;
        Harm = 6;
    case (4)
        Harm_Factor = 4/5;
        Harm = 5;
	case (5)
        Harm_Factor = 3/4;
        Harm = 4;
    case (6)
        Harm_Factor = 5/7;
        Harm = 7;
	case (7)
        Harm_Factor = 2/3;
        Harm = 3;
	case (8)
        Harm_Factor = 0.629961;
        Harm = 2;
	case (9)
        Harm_Factor = 3/5;
        Harm = 5;
	case (10)
        Harm_Factor = 4/7;
        Harm = 7;
	case (11)
        Harm_Factor = 0.529732;
        Harm = 2;
	case (12)
        Harm_Factor = 1/2;
        Harm = 2;
	case (13)
        Harm_Factor = 0.471937;
        Harm = 2;
	case (14)
        Harm_Factor = 0.445449;
        Harm = 2;
    case (15)
        Harm_Factor = 3/7;
        Harm = 7;
    case (16)
        Harm_Factor = 2/5;
        Harm = 5;
    case (17)
        Harm_Factor = 0.374577;
        Harm = 2;
    case (18)
        Harm_Factor = 0.353553;
        Harm = 2;
    case (19)
        Harm_Factor = 1/3;
        Harm = 3;
    case (20)
        Harm_Factor = 0.31498;        
        Harm = 2;
end
end