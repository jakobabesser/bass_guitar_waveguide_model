function [sos, mu0, pd0, phi0] = adf(f0,B,df,beta)
% adf.m
%
% Allpass dispersion filter design  
% 
% Ref.
% J.S. Abel, V. Valimaki, and J.O. Smith, "Robust, Efficient Design of
% Allpass Filters for Dispersive String Sound Synthesis," IEEE Signal
% Processing Letters, 2010.
%
% Parameters:
% f0 = fundamental frequency, Hz
% B = inharmonicity coefficent, ratio (e.g., B = 0.0001)
% df = design bandwidth, Hz 
% beta = smoothing factor (e.g., beta = 0.85)
%
% Examples:
% sos = adf(32.702,0.0002,2100,0.85);
% sos = adf(65.406,0.0001,2500,0.85);
% sos = adf(130.81,0.00015,4300,0.85);
%
% The output array sos contains the allpass filter coefficients
% as second-order sections.
% 
% Created: Vesa Valimaki, Dec. 11, 2009
% (based on Jonathan Abel's Matlab code)

%% initialization

% system variables
fs = 44100;		%% sampling rate, Hz
nbins = 2048;	%% number of frequency points

%% design dispersion filter

% period, samples; df delay, samples; integrated delay, radians
tau0 = fs/f0;   %% division needed
pd0 = tau0/sqrt(1 + B*(df/f0).^2);  %% division and sqrt needed
mu0 = pd0/(1 + B*(df/f0)^2);
phi0 = 2*pi*(df/fs)*pd0 - mu0*2*pi*df/fs;

% allpass order, biquads; desired phases, radians
nap = floor(phi0/(2*pi));
phik = pi*[1:2:2*nap-1];

% Newton single iteration
etan = [0:nap-1]/(1.2*nap) * df;  %% division needed
pdn = tau0./sqrt(1 + B*(etan/f0).^2); %% division and sqrt needed
taun = pdn./(1 + B*(etan/f0).^2);
phin = 2*pi*(etan/fs).*pdn;
theta = fs/(2*pi) * (phik - phin + (2*pi/fs)*etan.*taun) ./ (taun - mu0);
% division needed

% compute allpass pole locations
delta = diff([-theta(1) theta])/2;
cc = cos(theta * 2*pi/fs);
eta = (1 - beta.*cos(delta * 2*pi/fs))./(1 - beta);  %% division needed
alpha = sqrt(eta.^2 - 1) - eta;  % sqrt needed

% form second-order allpass sections
temp = [ones(nap,1) 2*alpha'.*cc' alpha'.^2];
sos = [fliplr(temp) temp];

