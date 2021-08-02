fs = 44100;
duration = 1;
amplitude = 1;
f0 = 41.2034; %% low e-string
numHarm = 5;
decay = 0.95;
inharm = 0.001; %% this is reasonable for e-bass
zero_padding = 5000;

%% simulate bass guitar note with inharmonicity
sig = ToneGenerator(fs, f0, amplitude, duration, decay, numHarm, inharm);
sig = [zeros(zero_padding,1);sig];

%% ------------------------------------------------------------------------
%% VARIANT 1: Synthesize with higher fundamental frequency and shift down
%% afterwards by means of fft->ifft->analytic_signal->freq shift amplitude
%% modulation
%% -> this cannot reproduce the inharmonicity formula
%% compute new fundamental frequency based on the inharmonicity
factor = numHarm.*sqrt(1+(numHarm.^2-1)*inharm); %% take the maximum deviation
new_f0 = f0*(factor/numHarm);
shift = f0-new_f0;       %% in Hz

new_sig = ToneGenerator(fs, new_f0, amplitude, duration, decay, numHarm, 0);
new_sig = [zeros(zero_padding,1);new_sig];

[ana_sig,envelope,phase,frequency] = analytic_signal_via_fft(new_sig,fs);

%% introduce frequency shift
arg = linspace(0,shift*length(ana_sig)/fs,length(ana_sig))';
inharm_sig = real(ana_sig.*exp(j.*arg.*2.*pi));

hold off
plot(sig)
hold on
plot(2*inharm_sig,'r');

%% ------------------------------------------------------------------------
%% VARIANT 2: Synthesize with original fundamental frequency and shift each
%% partial individually by means of fft->ifft->analytic_signal->freq shift amplitude
%% modulation
%% this method can approximate the inharmonicity formula but may lead to
%% fft artifacts and is not suited for time varying f0
new_sig = ToneGenerator(fs, f0, amplitude, duration, decay, numHarm, 0);
string = 1;
fret = 0;
[new_sig, sNum] = BassGuitar_Decoder( 'BA', createNotesStructure(Fret_Tone('BA',string,fret), 'FS', 'NO', 0, 0, [0,0], 0, 1, 0, 1),[string], 120, 0.0);
f0=Fret_Tone('BA',string,fret);
new_sig = [zeros(zero_padding,1);new_sig'];

%% compute large fft on the signal
blocksize = length(new_sig);

%% compute fft
f = fft(new_sig,blocksize);

%% set mirror spectrum to zero in order to receive analytic signal on ifft
f([round(length(f)/2):end]) = 0;
delta_f = fs/length(f);

mask_width = (new_f0/2)/delta_f;
shifted_partial = [];

%% here, a lower number might be suffient perceptually
%% since the inharmonicity sensation is probably led by the lower
%% harmonics
upperLimit = numHarm;

for k = 1:upperLimit
  
  %% compute center frequency of each harmonic
  cf = (new_f0*k)/delta_f;
  
  test(k)=cf;
  
  %% extend the mask a bit
  mask = zeros(size(f));
  mask(round((cf-mask_width):(cf+mask_width))) = 1;
  
  %% for the first partial include energy below
  if (k == 1)
    mask(1:round(cf)) = 1;
  end
  
  %% for the last partial include energy above
  if (k == upperLimit)
    mask(round(cf):end) = 1;
  end
  
  hold off
  plot(abs(f));
  hold on
  plot(mask*max(abs(f)),'r');
  
  %% mask each partial and it's surroundings
  ff = f.*mask;
  partial = ifft(ff,blocksize);
  
  this_f0 = f0*k.*sqrt(1+(k.^2-1)*inharm); 
  ideal_f0 = f0*k;
  shift = (this_f0-ideal_f0);  %% in Hz
  
  %% apply frequency shift to each partial individually
  arg = linspace(0,shift*length(partial)/fs,length(partial))';
  shifted_partial(:,k) = real(partial.*exp(j.*arg.*2.*pi));
  
  hold off
  plot(real(partial));
  hold on
  plot(shifted_partial(:,k),'r');
  
  1;
  
end

inharm_sig = sum(shifted_partial')';
inharm_sig(1:zero_padding) = 0; %% remove pre-echo

hold off
plot(sig)
hold on
plot(2*inharm_sig,'r');
