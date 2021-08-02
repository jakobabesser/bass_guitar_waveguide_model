function [ melody_out, sNumbers ] = BassGuitar_Decoder( instr, notes, sNumbers, BPM, pause_time )
% This function creates a melody out of a given structure of notes
% containing informations about the notes fundamental frequencies, start 
% times, end times, dynamics, plucking styles, expression styles and 
% expression style parameters.
% 
% REFERENCES:
%
% INPUT:
%       instr:          instrument to use ('BA', 'GU')
%       notes:          structure of different notes defined by the
%                       function "CreateNotesStructure"
%       sNumbers:       strings to be used for notes (optional)
% 
% OUTPUT:
%       melody_out:   	resulting output
%       sNumbers:       string choice for each note
%
% FUNCTION CALLS:
%       Frq2BassString
%       String_NextString
%       WaveGuide_BassGuitar
%


%% setting up sampling frequency
fs = 44100;

%% load body filter

%% getting number of notes
num_notes = length(notes);

%% getting t_max
t_max = max(arrayfun(@(x)max(x.t_end), notes));
%max([notes(:).t_end])

% filling string numbers and final output with zeros
if nargin < 2
sNumbers = zeros(1, num_notes);
end

melody_out = zeros(1, ceil(t_max*fs));

%% creating note after note
for num = 1:num_notes
    %% getting string on which note is played
    if num == 1 && sNumbers(num) == 0
        sNumbers(num) = Frq2BassString(instr, notes(num).f0);
    elseif sNumbers(num) == 0
        sNumbers(num) = String_NextString(instr, sNumbers(num-1), notes(num-1).f0, notes(num).f0);
    end
    
    %% getting start time of note
    start = floor(notes(num).t_start*fs+1);
    
    %% creating note
    tone = WaveGuide_BassGuitar(instr, notes(num), sNumbers(num), fs);
    
    
    %% adding note to melody
    temp = melody_out(start:start+length(tone)-1);
    % has to be reworked, try scaling each amplitude then mixing
    melody_out(start:start+length(tone)-1) = (temp+tone); %-temp.*tone);
    
end

%% normalizing melody
%melody_out = melody_out / max(abs(melody_out));

%% append silence until the end of the bar

if( pause_time > 0)
    melody_out( (length(melody_out)+1):(length(melody_out)+pause_time/BPM *4 *60 * fs) ) = 0;
end

end