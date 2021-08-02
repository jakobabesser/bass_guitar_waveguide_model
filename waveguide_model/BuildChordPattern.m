function [ chordvec ] = BuildChordPattern( root, mode, seventh, barre_base )

% REFERENCES:
%
% INPUT:
%       root:       root of the chord to play
%       mode:       maj/min
%       seventh:    min7/maj7/no7
%       barre_base: barre chord to use
%
% OUTPUT:
%       chordvec:   the chord pattern as a vector
%



% Scale for shifting the chord
scale(1).note = 'C';
scale(2).note = 'C#';
scale(3).note = 'D';
scale(4).note = 'D#';
scale(5).note = 'E';
scale(6).note = 'F';
scale(7).note = 'F#';
scale(8).note = 'G';
scale(9).note = 'G#';
scale(10).note = 'A';
scale(11).note = 'A#';
scale(12).note = 'B';

% Calculate distance between barre base chord and root chord in half tones
barre_base_num = 0;
root_num = 0;

for i=1:12
    if( strcmp(scale(i).note, barre_base) ), barre_base_num = i; end;
    if( strcmp(scale(i).note, root) ), root_num = i; end;
end

dist = mod(12 - barre_base_num + root_num, 12);

% Load chordfile
chord_file = strcat('Chordfiles/', barre_base, '_open.txt');
fid = fopen(chord_file, 'r');

chordvec = fscanf(fid, '%d', [6, 6]);

switch strcat(mode, seventh)
    case('majno7')
        chordvec = chordvec(:,1);
    case('minno7')
        chordvec = chordvec(:,2);
    case('majmaj7')
        chordvec = chordvec(:,3);
    case('minmaj7')
        chordvec = chordvec(:,4);
    case('majmin7')
        chordvec = chordvec(:,5);
    case('minmin7')
        chordvec = chordvec(:,6);
end

% Add half tone distance
chordvec = chordvec + dist;

