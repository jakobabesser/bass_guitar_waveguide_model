function [ bestBetas, orig_decayT_dB_s ] = tune_frequency_decay_and_inharmonicity( )
%TUNE_FREQUENCY_DECAY Summary of this function goes here
%   Detailed explanation goes here
close all;
fs = 44100;
instr = 'BA';

% betaValues(:,1) = (0.1:0.1:2.0);
betaValues(1,1) = (1.0);
% betaValues = [1.0; 1.0; 1.0; 1.0];

% [ testNote, dummy ] = BassGuitar_Decoder(instr, note, string, 120, 0.1, 'betaIn', betaValues(1), 'inharm', 1);
% wavwrite(testNote, fs, ['C:\BassGuitarSynthOut\FreqDecayTune\BassSynthFreqTune_',int2str(string),'_',int2str(fret),'_beta_', num2str(betaValues(1)),'.wav']);
for string = 1:4
    for fret = 0:12

        f0 = Fret_Tone(instr, string, fret);
        %note = CreateNotesStructure(f0, 'FS');
       
        [orig_decayT_dB_s(string, fret+1), orig_deltaDecayF_dB_Hz_s(string, fret+1), orig_decayT_dB_Hz(string, fret+1)] = estimate_temporal_and_spectral_decay_from_single_notes(['C:\single_notes_no\BS_1_EQ_1_FS_NO_',int2str(string),'_',int2str(fret),'.wav'],'VIS', 0);

%         InharmBetas_holistic(string, fret+1) = smt_bst_estimate_inharmonicity_coefficient_from_complete_note(['C:\single_notes_no\BS_1_EQ_1_FS_NO_',int2str(string),'_',int2str(fret),'.wav'], f0, 'method', 'holistic');
%         InharmBetas_harm_peak_freqs(string, fret+1) = smt_bst_estimate_inharmonicity_coefficient_from_complete_note(['C:\single_notes_no\BS_1_EQ_1_FS_NO_',int2str(string),'_',int2str(fret),'.wav'], f0, 'method', 'harmonic_peak_frequencies');
        
        note = CreateNotesStructure( f0, 'FS', 'NO', 0, 0, [string,fret], 0.1, 3.1, 0, orig_decayT_dB_s(string, fret+1));
        
        bestDistance = 10;

%         for currBeta = 1:size(betaValues)
%             disp(sprintf('string: %u', string));
%             disp(sprintf('fret: %u', fret));
%             disp(sprintf('betaValue: %f', betaValues(currBeta)));
%             [ testNote, dummy ] = BassGuitar_Decoder(instr, note, string, 120, 0.1, 'inharm', 0);
% 
%             wavwrite(testNote, fs, ['C:\BassGuitarSynthOut\FreqDecayTune\BassSynthFreqTune_',int2str(string),'_',int2str(fret),'_beta_', num2str(betaValues(currBeta)),'.wav']);
% 
%             [decayT_dB_s(string, fret+1), deltaDecayF_dB_Hz_s(string, fret+1), decayT_dB_Hz(string, fret+1)] = estimate_temporal_and_spectral_decay_from_single_notes(['C:\BassGuitarSynthOut\FreqDecayTune\BassSynthFreqTune_',int2str(string),'_',int2str(fret),'_beta_', num2str(betaValues(currBeta)),'.wav'],'VIS', 0);
% 
%             if (abs(orig_deltaDecayF_dB_Hz_s(string, fret+1)-deltaDecayF_dB_Hz_s(string, fret+1))<bestDistance)
%                 bestDistance = abs(orig_deltaDecayF_dB_Hz_s(string, fret+1)-deltaDecayF_dB_Hz_s(string, fret+1));
%                 bestBetas(string, fret+1) = betaValues(currBeta);
%             end
% 
%             all_deltaDecayF_dB_Hz_s(currBeta)=deltaDecayF_dB_Hz_s(string, fret+1);
%             all_decayT_dB_s(currBeta)=decayT_dB_s(string, fret+1);
% 
% 
%         end

    end
end

plot(orig_deltaDecayF_dB_Hz_s);
% plot(orig_decayT_dB_Hz);
% save 'FilterBetas.mat' bestBetas
% save 'DecayRates.mat' orig_decayT_dB_s
% save 'InharmBetasHolistic.mat' InharmBetas_holistic
% save 'InharmBetasHarmPeakFreqs.mat' InharmBetas_harm_peak_freqs

%[decayT_dB_s(string, fret+1), deltaDecayF_dB_Hz_s(string, fret+1), decayT_dB_Hz(string, fret+1)] = estimate_temporal_and_spectral_decay_from_single_notes(['C:\BassGuitarSynthOut\FreqDecayTune\BassSynthFreqTune_',int2str(string),'_',int2str(fret),'_beta_', num2str(bestBeta),'.wav'],'VIS', 0);

% 
% 
% orig_decayT_dB_s
% all_decayT_dB_s
% orig_deltaDecayF_dB_Hz_s
% all_deltaDecayF_dB_Hz_s
end

