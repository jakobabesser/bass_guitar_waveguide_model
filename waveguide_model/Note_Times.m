function [ times ] = Note_Times( notes, BPM )
% This function calculates the duration of certain note values for given
% beats per minute (BPM).
% 
% REFERENCES:
%
% INPUT:
%       notes:         	note values
%                       1 - full note
%                       2 - half note
%                       3 - dotted-quarter note
%                       4 - quarter note
%                       5 - dotted-eighth note
%                       6 - triplet-quarter note
%                       7 - eighth note
%                       8 - dotted-sixteenth note
%                       9 - triplet-eighth note
%                       10 - sixteenth note
%                       11 - triplet-sixteenth note
%       BPM:            beats per minute
%
% OUTPUT:
%       times:          note times (s)
%
% FUNCTION CALLS:
%


%% creating variable
times = zeros(1, length(notes));

%% getting duration from note value & BPM
for num = 1:length(notes)
    switch notes(num)
        case (1)
            %% full note
            times(num)=240/BPM;
        case (2)
            %% half note
            times(num)=120/BPM;
        case (3)
            %% dotted-quarter note
            times(num)=90/BPM;
        case (4)
            %% quarter note
            times(num)=60/BPM;
        case (5)
            %% dotted-eighth note
            times(num)=45/BPM;
        case (6)
            %% triplet-quarter note
            times(num)=40/BPM;
        case (7)
            %% eighth note
            times(num)=30/BPM;
        case (8)
            %% dotted-sixteenth note
            times(num)=22.5/BPM;
        case (9)
            %% triplet-eighth note
            times(num)=20/BPM;
        case (10)
            %% sixteenth note
            times(num)=15/BPM;
        case (11)
            %% triplet-sixteenth note
            times(num)=10/BPM;
    end
end
end

