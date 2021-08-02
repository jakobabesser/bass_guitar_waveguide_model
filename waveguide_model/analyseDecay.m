function [  ] = analyseDecay(  )
%ANALYSEDECAY Summary of this function goes here
%   Detailed explanation goes here
for string = 1:1
    for fret = 1:12
        [note, sNum] = BassGuitar_Decoder( 'BA', createNotesStructure(Fret_Tone('BA',string,0), 'FS', 'NO', 0, 0, [0,0], 0, 2, 0, 4*fret),[string], 120, 0.1);
        wavwrite(note, 44100, ['c:\notes\same_note_diff_decay_time\note_FS_NO_', int2str(string),'_',int2str(fret),'.wav']);
    end
end
%[decayT_dB_s, decayT_dB_Hz] = estimate_temporal_and_spectral_decay_from_single_notes(note);
%sound(note, 44100);
end

