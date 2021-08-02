function [ audioOut, strings ] = create_melody_from_struct( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

instr = 'BA'; %set to bass

[params, melodyNumber, filePrefix, folder, setAllES2NO, setAllPS2FS]   = process_options(varargin,...
                        'params',0, ...    
                        'melodyNumber',0, ...    
                        'filePrefix','', ...
                        'folder', '', ...
                        'setAllES2NO', 0, ...
                        'setAllPS2FS', 0);

if params == 0
    load('H:\workspace\matlab_svn\MatlabDocumentation\Repository\Projects\DatasetGeneration\SMT_BASS_SINGLE_TRACKS\data\SMT_BASS_SINGLE_TRACKS_with_slides.mat', 'params');
end
                    
[dummy, totalMelodyNumber] = size(params);

if melodyNumber == 0
    firstMelody = 1;
    [dummy, totalMelodyNumber] = size(params);
else
    firstMelody = melodyNumber;
    totalMelodyNumber = melodyNumber;
end

for mel = firstMelody:totalMelodyNumber
    [dummy, totalNoteNumber] = size(params{mel});
    
    for noteNum = 1:totalNoteNumber
        %% run if "note" is not a pause
        %if strcmp(Pluck_Styles(num, :), 'PA') == 0

        f0 = midi2freq(params{mel}(noteNum).pitch);
        if (setAllPS2FS == 1)
            pluckStyle = 'FS';
        else
            pluckStyle = params{mel}(noteNum).PS;
        end
        if (setAllES2NO == 1)
            exprStyle = 'NO';
        else
            exprStyle = params{mel}(noteNum).ES;
        end
        cent = params{mel}(noteNum).deltaFHub;
        fVib = params{mel}(noteNum).fMod;
        fingerPos(1) = params{mel}(noteNum).SN;
        fingerPos(2) = params{mel}(noteNum).FN;
        tOnset = params{mel}(noteNum).onsetSec;
        tOffset = params{mel}(noteNum).offsetSec;

            %% creating note structure
            notes(noteNum) = CreateNotesStructure(f0 , pluckStyle, exprStyle, cent, fVib, fingerPos, tOnset, tOffset, 0, 0);
            strings(noteNum) = params{mel}(noteNum).SN;
            frets(noteNum) = params{mel}(noteNum).FN;
            %% incrementing note number
    %         Note_num = Note_num+1;
        %end

        %% adding note time to overall time
    %     t = t + times(num);

    end
    audioOut = zeros(1);
    [audioOut, d] = BassGuitar_Decoder(instr, notes, strings, 120, 0);
    audioOut = [zeros(1, 2000), audioOut, zeros(1, 2000)];
    wavwrite(audioOut, 44100, ['c:\BassGuitarSynthOut\',folder,filePrefix,'synth_melody_no_', int2str(mel),'.wav']);
    clear notes;
    clear strings;
    clear frets;
end

end

