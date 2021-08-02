function [ f_change, freq2 ] = Slide_model( freq1, cent, time, fs )
% This function creates a modelled frequency curve for sliding effects
% given the start frequency and cent difference.
% 
% REFERENCES:
%
% INPUT:
%       freq1:          start frequency (Hz)
%       cent:           difference in cent
%       time:           duration (s)
%       fs:             fundamental frequency (Hz)
%
% OUTPUT:
%       f_change:    	resulting frequency curve
%       freq2:          target frequency
%
% FUNCTION CALLS:
%
% $Date$ $Revision$ $Author$


%% getting target frequency
freq2 = cent2freq_WGSynth(freq1, cent);

%% calculating frequncy difference
freq_diff = freq2 - freq1;

%% calculating frequency changing curve

f_st = zeros(1,round(time*fs/20));
steps = freq2midi(freq2,1)-freq2midi(freq1,1);
fracTime = time/8/steps;
f_slope = [];
for i=1:steps
    f_slope = [f_slope ones(1,round(fracTime*fs))*(midi2freq(freq2midi(freq1,1)+i)-freq1)];
end
f_end = ones(1,round(time*fs-length(f_slope)-length(f_st)-1))*freq_diff;
wL = round(fs/40);
f_all = [f_st f_slope f_end ones(1,wL)*freq_diff];
wind = hann(wL)/sum(hann(wL));
f_conv = conv(f_all, wind');
f_change = f_conv(1:round(time*fs));

end