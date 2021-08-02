function [ FretPos ] = CalcFretPositions( Scale )
% This function calculates the fret positions to a given scale length.
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


%% setting first fret position to scale
FretPos = Scale;

%% calculating fret positions
for x = 1:20
    FretPos = [FretPos FretPos(end)/2^(1/12)];
end

%% reversing order
FretPos=FretPos(end:-1:1);

end