function [ decayT_dB_s, decayT_dB_Hz ] = analyseDecayPartTwo(  )
%ANALYSEDECAY Summary of this function goes here
%   Detailed explanation goes here
close all;

for string = 1:1
    for fret = 1:1:12
        
        %note = wavread(['c:\notes\note_FS_NO_', int2str(string),'_',int2str(fret),'.wav']);
        [decayT_dB_s(string, fret), decayT_dB_Hz(string, fret)] = estimate_temporal_and_spectral_decay_from_single_notes(['c:\notes\same_note_diff_decay_time\note_FS_NO_', int2str(string),'_',int2str(fret),'.wav'],'VIS', 0);
        
    end
end
figure, imagesc(decayT_dB_s), colorbar;

figure, imagesc(decayT_dB_Hz), colorbar;
%sound(note, 44100);
end

