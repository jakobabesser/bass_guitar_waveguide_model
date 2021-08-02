function [ Notes, Strings ] = CreateMelody( instr, melody_file, BPM )
% This function creates the notes structure for a melody.
% 
% REFERENCES:
%
% INPUT:
%       instr:          instrument to use ('BA', 'GU')
%       melody_file:   	path & file name of note parameter file
%       BPM:            speed in beats per minute
%
% OUTPUT:
%       Notes:          resulting notes
%       Strings:        used strings
%
% FUNCTION CALLS:
%       Note_TapTiming
%       Note_Times
%       CreateNotesStructure
%


%% example input
% melody_file = 'Demofiles/Moloko_STSP.txt'; BPM = 130;

%% setting tapped timing ON or OFF
tap = 0;

%% reading song file
PS_code = ['FS';'PK';'MU';'ST';'SP';'PA';'HO';'PO']; % PA - Pause
ES_code = ['NO';'BE';'VI';'DN';'HA';'SL'];
note_params = 10;

fid = fopen(melody_file, 'r');
params(:, :) = fscanf(fid, '%d', [note_params, inf]);

Strings = params(1,:);
Frets = params(2, :);
Pluck_Styles = PS_code(params(3,:),:);
Expr_Styles = ES_code(params(4,:),:);
Note_Values = params(5, :);
Cent = params(6, :);
F_Vib = params(7, :);
Harm_Str_Fret(1,:) = params(8,:);
Harm_Str_Fret(2,:) = params(9,:);
dB = params(10,:);
dB = dB - rand(1,length(dB))*2;

%% determine f0 to fret position
f0 = Fret_Tone(instr, Strings, Frets);

%% getting timing for notes
if tap == 1
    %% getting tapped timing for notes
    times = Note_TapTiming(length(Strings));
else
    %% determine times to note values
    times = Note_Times(Note_Values, BPM);

    %% adding some random inaccuracy
    times = times + round(((rand(1, length(times))-rand(1, length(times)))*0.015)*1000)/1000;
    
end

%% setting up loop parameters
t = 0;
Note_num = 1;

%% creating notes structure - note by note
for num = 1:length(f0)
    %% run if "note" is not a pause
    if strcmp(Pluck_Styles(num, :), 'PA') == 0
        %% creating note structure
        Notes(Note_num) = CreateNotesStructure(f0(num), Pluck_Styles(num, :), Expr_Styles(num, :), Cent(num), F_Vib(num), Harm_Str_Fret(:,num), t, t+times(num), dB(num));
        
        %% incrementing note number
        Note_num = Note_num+1;
    end
    
    %% adding note time to overall time
    t = t + times(num);

end

end

