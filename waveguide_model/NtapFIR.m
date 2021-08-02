function[ B ] = NtapFIR( beta, M )
% This function creates a parametric FIR filter to simulate propagation
% losses in digital wavguide string models.
% 
% REFERENCES:
% "Parametric FIR Design of Propagation Loss Filters in Digital Waveguide
% String Models" by Maarten van Walstijn, May 2010
%
% INPUT:
%       beta:           design parameter [ beta = (b2*tau)/(c^2*T^2)]
%       M:              number of free parameters
%
% OUTPUT:
%       B:              FIR coefficient vector
%
% FUNCTION CALLS:
%


%% calculating filter coefficents
betai = beta.^(1:M);
A = zeros(M,M);
for i=1:M
    for m=1:M
        A(i,m) = ((2*(prod(1:i)))/prod(1:(2*i)))*(m^(2*i));
    end
end
theta = (A\(betai'))';

B = [fliplr(theta) (1 - 2*sum(theta)) theta];

end