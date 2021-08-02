function [ freq2 ] = cent2freq_WGSynth( freq1, cent )
% This function converts a given initial frequency and cent input to the 
% resulting frequency.
% 
% REFERENCES:
%
% INPUT:
%       freq1:          initial frequency (Hz)
%       cent:           difference in cent
% 
% OUTPUT:
%       freq2:          resulting frequency (Hz)
%
% FUNCTION CALLS:
%


%% calculating cent to frequncy
for x = 1:length(freq1)
    freq2(x)=freq1(x)*2^(cent(x)/1200);
end

end