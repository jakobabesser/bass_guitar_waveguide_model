function [ inharm ] = getSpectrum( testNote, f0 )


fs = 44100;
blocksize = 16*1024;
hopsize = 128;
zeroPaddingFactor = 4;
mSpec = spectrogram(testNote,hanning(blocksize),blocksize-hopsize,zeroPaddingFactor*blocksize);
mSpec = abs(mSpec);
[nBins,nFrames] = size(mSpec);



vT = (0:nFrames-1)*hopsize/fs;
vF = (0:nBins-1)/nBins*fs/2;

h = figure, 
mesh(vT(:,:),vF,20*log10(mSpec(:, :))) 
title('Magnitude spectrogram');
xlabel('t [s]')
ylabel('f [Hz]');
zlabel('a [dB]');
view(84,36)

binFreq = nBins * fs/blocksize;
% 
% figure, plot(20*log10(mSpec(:,500)));
% 
% stg.minHarm = 1;
% stg.maxHarm = 20;
% stg.maxPoly = 1;
% stg.margin = 1;
% stg.fmin = 30;
% stg.fmax = 100;
% stg.blocksize = 1024;
% stg.windowtype = 'hann';
% stg.fs = fs;

% note = multipitchEst_spectralSmoothness(mSpec, stg);

% inharm = estimate_inharmonicity_holistic(mSpec(:,1), vF, f0, 10, 0.01,1);

end

