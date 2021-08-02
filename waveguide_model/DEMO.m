%function [ OUT ] = DEMO( )
% This function demonstrates the bass guitar synthesis algorithm.
% 
% REFERENCES:
%
% INPUT:
%
% OUTPUT:
%       OUT:    output audio signal
%
% FUNCTION CALLS:
%



%% Switch instrument, BA:Bass Guitar, GU: Guitar
avail_instr = ['BA'; 'GU'];
instr = avail_instr(2,:);
BPM = 90;

body_filter = 0;

%% example input files with note parameters & example beats per minute
folder = 'Demofiles/';

% melody_file = 'GU_test_guit';
% melody_file = 'GU_ref3';
% melody_file = 'GU_ref4';
% melody_file = 'Em_CHORDS';
%  melody_file = '1241_CHORDS';
% melody_file = 'Blowing_CHORDS';
% melody_file = 'Blues_CHORDS';
% melody_file = 'CanonD_CHORDS';
% melody_file = 'GU_Stairway_PK_guit'; BPM = 130;
% melody_file = 'BA_Moloko_STSP'; BPM = 130;
melody_file = 'BA_Moloko_FS'; BPM = 130;
% melody_file = 'BA_Moloko_PK'; BPM = 130;
% melody_file = 'BA_Moloko_MU'; BPM = 130;
% melody_file = 'BA_BE_VI_FS'; BPM = 90;
% melody_file = 'BA_BE_VI_PK'; BPM = 90;
% melody_file = 'BA_BE_VI_MU'; BPM = 90;
% melody_file = 'BA_BE_VI_Slap'; BPM = 90;
% melody_file = 'BA_chromScale'; BPM = 120;
% melody_file = 'BA_BlackNight_FS'; BPM = 120;
% melody_file = 'BA_BlackNight_MU'; BPM = 120;
% melody_file = 'BA_BlackNight_PK'; BPM = 120;
% melody_file = 'BA_BlackNight_MUFS'; BPM = 120;
% melody_file = 'BA_BlackNight_STSP'; BPM = 120;
% melody_file = 'BA_Melody_FS'; BPM = 100;
% melody_file = 'BA_Melody_PK'; BPM = 100;
% melody_file = 'BA_Melody_MU'; BPM = 100;
% melody_file = 'BA_Melody_STSP'; BPM = 100;
% melody_file = 'BA_Harmonics'; BPM = 120;
% melody_file = 'BA_String_E_0_12'; BPM = 120;
% melody_file = 'BA_String_A_0_12'; BPM = 120;
% melody_file = 'BA_String_D_0_12'; BPM = 120;
% melody_file = 'BA_String_G_0_12'; BPM = 120;
% melody_file = 'BA_G_Major_Scale'; BPM = 120;

%% example picking patterns (chords only)

%patt_file = 'ref2';
%patt_file = '1241';
%patt_file = 'Blowing';
%patt_file = 'Blues';
%patt_file = 'Pat1';
patt_file = 'Pat2';
% patt_file = 'schlag';


%% adding folder to melody file name
melody_file = [folder, melody_file, '.txt'];

%% create notes structure
if strfind(melody_file,'CHORDS')
    [notes, strings, pause_time] = CreateChord(instr, melody_file, patt_file, BPM);
else
    if strfind(melody_file,'BA_')
    
    [notes, strings] = CreateMelody(avail_instr(1,:), melody_file, BPM);
    pause_time = 0;
    
    elseif strfind(melody_file,'GU_')
    
    [notes, strings] = CreateMelody(avail_instr(2,:), melody_file, BPM);
    pause_time = 0;
    
    end
end
%% synthesise melody
[OUT, d] = BassGuitar_Decoder(instr, notes, strings, BPM, pause_time);

%% play synthesised melody
sound(OUT, 44100);

%% apply body model
out1 = OUT;
out2 = BodyModel(out1, 1);
