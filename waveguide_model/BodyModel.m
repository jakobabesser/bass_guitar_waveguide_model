function [ sig_out ] = BodyModel( sig_in, drywet)
% Apply body-filter to input signal with a dry/wet control
% INPUT:
%       sig_in: clean synthetic guitar signal
%       drywet: control dry/wet portion [0..1] with 0 meaning dry-only
%               ans 1 meaning wet-only
%
% OUTPUT:
%       sig_out: dirty output signal
%


% load filter parameters
load('bodyfilter.mat');
% a=a306;
% a=a71;

a=a10;
b=1;

% compute wet signal
wet = filter(b,a,sig_in);

% apply dry/wet control
sig_out = sig_in * (1-drywet) + wet * drywet;
% normalise signal
sig_out = sig_out ./ max(abs(sig_out));


end

