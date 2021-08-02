function [ vib_curve ] = BendVib_Segments(f0, segm_cents, segm_times, fs)
% This function creates a varying frequency curve out of given turning
% points.
% 
% REFERENCES:
%
% "Automatic Recognition and Parametrization of Frequency Modulation
% Techniques in Bass Guitar Recordings" by Jakob Abeﬂer, Christian Dittmar
% and Gerald Schuller, 2011
%
% INPUT:
%       f0:                 fundamental frequency
%       segm_cents:         cents for segment frequencies
%       segm_times:         segment times
%       fs:                 sampling frequency
% 
% OUTPUT:
%       vib_curve:          resulting frequency curve
%
% FUNCTION CALLS:
%
% Author: krampk
% Created: June 2011
% Fraunhofer IDMT. Copyright 2011

%   $Date: 2013-10-14 13:33:24 +0200 (Mon, 14 Oct 2013) $ $Revision: 8606 $ $Author: kar $

%% example input values
% f0 = 55;
% segm_cents = [57.1, 0, 53, 10, 56.5, 5];
% segm_times = [0.4, 0.9, 1.5, 2.1, 2.5, 3];
% fs = 44100;

%% filling segments with f0 at the beginning
% segm_cents = [0, segm_cents];
% segm_times = [0, segm_times];

%% calculating frequencies
f0s(1:length(segm_cents)) = f0;
freqs = cent2freq_WGSynth(f0s, segm_cents);

%% calculating frequncy difference
freqs = freqs - f0;

%% getting number of segments
segments = length(freqs)-1;

%% allocating variable
vib_curve = [];

%% creating curve segment by segment
for segment=1:segments
    %% getting frequency & time difference
    freq_diff = freqs(segment+1) - freqs(segment);
    time_diff = segm_times(segment+1) - segm_times(segment);
    
    %% creating time samples
    t = (1:1:fs*time_diff);
    
    %% setting up parameters for sin rise or fall
    freq = 1/time_diff;
    f = freq/fs;
    c = -pi/2;
    b = 0.5;
    
    %% calcualting curve segment
    curve_segment = (freq_diff.*(0.5*sin(b*2*pi*t*f+c)+0.5))+freqs(segment);
    
    %% adding curve segment to curve
    vib_curve = [vib_curve, curve_segment(1:end-1)];
    
end
%% adding last curve value to the end
vib_curve = [vib_curve, curve_segment(end)];

%% plotting curve
figure, plot(vib_curve, 'color', 'k');
axis([0,length(vib_curve), 0, max(vib_curve)+0.1]);
xlabel('Zeit [Samples]');
ylabel('Frequenzhub [Hz]');
set(gcf,'color', 'white');
end