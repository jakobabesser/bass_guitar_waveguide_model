function [ nextString, nextFret ] = String_NextString( instr, String_old, old_f0, f0 )
% This function finds the nearest fret for a given new f0 to a given
% previously "played" f0 with its corresponding previously "played" string.
% 
% REFERENCES:
%
% INPUT:
%       instr:          instrument to use ('BA', 'GU')
%       String_old:     previous "played" string (1-4)
%       old_f0:         previous "played" fundamental frequncy (Hz)
%       f0:          	fundamental frequncy (Hz)
%
% OUTPUT:
%       nextString:    	resulting string
%       nextFret:       resulting nearest fret
%
% FUNCTION CALLS:


%% loading bass note frequencies

switch instr
    case('BA')
        VarStruct = load('BassTones.mat');
        Tones = VarStruct.BassTones;
    case('GU')
        VarStruct = load('GuitarTones.mat');
        Tones = VarStruct.GuitarTones;
end 
       

%% finding old fret to string & f0
Fret_old = find(Tones(String_old,:)<old_f0+1, 1, 'last')-1;

%% creating matrizes with frets next to the old fret
Frets_next_r = Tones(:,Fret_old+1:end);
Frets_next_l = Tones(:,Fret_old+1:-1:1);

%% finding all frets for new f0
[Tone_String_r, Tone_Fret_r]=find(cent2freq_WGSynth(f0, -50) <Frets_next_r(:,:) & Frets_next_r(:,:)<=cent2freq_WGSynth(f0, 50));
[Tone_String_l, Tone_Fret_l]=find(cent2freq_WGSynth(f0, -50) <Frets_next_l(:,:) & Frets_next_l(:,:)<=cent2freq_WGSynth(f0, 50));

%% finding nearest fret
if numel(Tone_String_l) ~= 0 || numel(Tone_String_r) ~= 0
    if isempty(Tone_String_r)
        nextString = Tone_String_l(1);
        nextFret = Fret_old-Tone_Fret_l(1)+1;
    elseif isempty(Tone_String_l)
        nextString = Tone_String_r(1);
        nextFret = Fret_old+Tone_Fret_r(1)-1;
    elseif Tone_Fret_r(1) < Tone_Fret_l(1)
        nextString = Tone_String_r(1);
        nextFret = Fret_old+Tone_Fret_r(1)-1;
    else
        nextString = Tone_String_l(1);
        nextFret = Fret_old-Tone_Fret_l(1)+1;
    end
else
    nextString = 6;
    nextFret = 20;
end