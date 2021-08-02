function [ Fret ] = Tone_Fret( instr, String, Fret_Tone )
% This function translates a given bass string and fundamental frequency to
% its corresponding fret number.
% 
% REFERENCES:
%
% INPUT:
%       instr:          instrument to use ('BA', 'GU')
%       String:      	bass guitar string number (1-4)
%       Fret_Tone:     	fundamental frequency (Hz)
%
% OUTPUT:
%       Fret:           bass guitar fret number (1-20)
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

%% finding fret to frequency
Fret=find(Tones(String,:)<Fret_Tone+1, 1, 'last')-1;

end