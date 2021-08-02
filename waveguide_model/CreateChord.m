function [ Notes, Strings, pause_time, num_bars ] = CreateChord( instr, melody_file, patt_file,  BPM )
% This function builds a series of notes from a given chord progression
% and picking pattern. 
% 
% REFERENCES:
%
% INPUT:
%       instr:          instrument to use ('BA', 'GU')
%       melody_file:   	path & filename of chord progression file
%       BPM:            speed in beats per minute
%       patt_file:      path & filename of the picking pattern
%
% OUTPUT:
%       Notes:          resulting notes
%       Strings:        used strings
%       pause_time:     pause time to add after the last note in the bar
%       num_bars:       number of bars used in chord progression
%



% instr = 'GU';
% melody_file = 'Demofiles/Em_CHORDS.txt';
% BPM = 130;

%% calculate note timing
barlength = 60*4/BPM;
%% open file with chord progression
fid = fopen(melody_file);

%% read parameters and build a struct for each chord
params = textscan(fid, '%s %s %s %s %f');

for i=1:length(params{1})
    Chords(i).root = params{1,1}{i};
    Chords(i).mode = params{1,2}{i};
    Chords(i).seventh = params{1,3}{i};
    Chords(i).barre_base = params{1,4}{i};
    Chords(i).arpfact = params{1,5}(i);
end

num = 1;    %counter for note number

%% for each chord do: 
for chord_num=1:length(Chords)

    chordvec = BuildChordPattern( Chords(chord_num).root, Chords(chord_num).mode, Chords(chord_num).seventh, Chords(chord_num).barre_base);
 
    %% set picking-pattern
    
    root = 'Patterns/';
    patfile = strcat(root, patt_file, '.txt');
    fid = fopen(patfile, 'r');
    tabvec = fscanf(fid, '%d');
    tabvec = reshape(tabvec, length(tabvec)/8, 8)';

    input = tabvec;
   
    %% find columns with no events at the end of a bar to add silence/pause 
    
    pause = sum(input(1:6,:));
    
    for z1 = length(pause):-1:1
       if( pause(z1) ~= 0 )
           pause_index = z1 +1;
           break;
       end
    end
    
    if( pause_index <= length(pause) )
        pause_time = sum( input(7, pause_index:length(pause))./input(8, pause_index:length(pause)) );
    else
        pause_time = 0;
    end
    
    %% set up note parameters for all notes in a chord
    t_notes = 0;
    for string=1:6
   
        % Basic note parameters
        f0 = Fret_Tone('GU', string, chordvec(string));
        Pluck_Style = 'FS';
        Expr_Style = 'NO';
        cent = 0;
        f_vib = 0;
        harm_str_fret = [0, 0];
        dB = 0;
        decay_rate = 0;
        
		% arpeggio factor not in use yet
        arpeggiofactor = Chords(chord_num).arpfact;
        
        % repeat, while string is not empty
        while( sum(input(string,:)) ~= 0);
            %find maximum and its index
            maxim = max(input(string,:));
            ind_max = find(input(string,:)==maxim);
            
            for i=1:length(ind_max)
                
                % indices for start/stop in picking pattern matrix
                start = ind_max(i)- (maxim-1);
                stop = ind_max(i);
                
                % calculate note values for onset and duration
                onset = sum( input(7,1:start)./input(8,1:start), 2 ) - sum ( input(7,start)./input(8,start),2);   
                duration = sum( input(7, start:stop)./input(8,start:stop),2 );
                
                % calculate note times in seconds
                t_start = onset * barlength + (chord_num-1) * barlength;
                t_end = (onset + duration) * barlength + (chord_num-1) * barlength;
                
                % add human inaccuracy (in seconds)
                inaccuracy_t = rand * 0.045;
                t_start = t_start + inaccuracy_t;
                t_end = t_end + inaccuracy_t;
                inaccuracy_db = (rand-1)*0.7;
                dB = inaccuracy_db;
                
                % delete note from matrix, continue with remaining ones
                input(string, (ind_max(i)- (maxim-1):ind_max(i)) ) = 0;
                
                Notes(num) = CreateNotesStructure(f0, Pluck_Style, Expr_Style, cent, f_vib, harm_str_fret, t_start, t_end, dB, decay_rate);
                Strings(num) = string;
                num = num + 1;
            end

        end
          
    end
end

num_bars = chord_num;
