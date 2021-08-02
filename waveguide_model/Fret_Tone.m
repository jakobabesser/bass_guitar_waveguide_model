function [ Fret_Tone ] = Fret_Tone( instr, String, Fret )
% This function translates a given bass string and fret number to its
% corresponding fundamental frequency.
% 
% REFERENCES:
%
% INPUT:
%       instr:          instrument to use ('BA', 'GU')
%       String:      	bass guitar string number (1-4)
%       Fret:           bass guitar fret number (1-20)
%
% OUTPUT:
%       Fret_Tone:     	fundamental frequency (Hz)
%
% FUNCTION CALLS:
%


%% loading bass note frequencys


switch instr
    case('BA')
        VarStruct = load('BassTones.mat');
        Tones = VarStruct.BassTones;
    case('GU')
        VarStruct = load('GuitarTones.mat');
        Tones = VarStruct.GuitarTones;
end   
      
%% creating variable
Fret_Tone = zeros(1, length(String));

%% getting frequencies to string & fret number
for num = 1: length(String)
    Fret_Tone(num) = Tones(String(num), Fret(num)+1);
end
    
    
end