function [ W_left, W_right ] = loss_filter( W_left, W_right, FilterPos, length_fact, LF_coeff, m, length_W)
% This function filters the left and right travelling waves at a specific
% point in the digital delay line to simulate the frequency losses of the
% string stiffness, bridge and nut.
% 
% REFERENCES:
%
% INPUT:
%       W_left:        	travelling wave to the left
%       W_right:      	travelling wave to the right
%       FilterPos:     	filter position in the delay line
%       length_fact:    length factor
%       LF_coeff:       filter coefficients of loss filter
%       m:              left wave pointer
%       length_W:       length of waves
%
% OUTPUT:
%       W_left:        	travelling wave to the left
%       W_right:      	travelling wave to the right
%
% FUNCTION CALLS:
%


%% calculating filter length
Filt_len = length(LF_coeff);
Filt_len_half = floor(Filt_len/2);

%% getting left & right travelling wave state at filter position
LF_leftPos = round((FilterPos+m)*length_fact);
LF_leftWave = W_left(mod(LF_leftPos, length_W)+1);

%% getting next filter positon
LF_leftPos_next = round((FilterPos+m+1)*length_fact);

%% getting all values between the two filter positions
if LF_leftPos_next == LF_leftPos
	LF_leftWave_all = LF_leftWave;
else
	LF_leftWave_all = W_left(mod(LF_leftPos:1:LF_leftPos_next-1, length_W)+1);
end
   
%% getting new filtered values
for loop = 0:length(LF_leftWave_all)-1
	%% filtering value with filter coefficients
    bridge = LF_coeff * W_left( mod((LF_leftPos-Filt_len_half-1+loop)+(1:Filt_len), length_W)+1)';
    
    %% writing new value back to traveling waves 
    W_left(mod(LF_leftPos+loop, length_W)+1) = bridge;
	W_right((mod(length_W-LF_leftPos-loop, length_W)+1)) = -bridge;
    
    %% setting last value equal to first one
    W_right(end) = W_right(1);
    W_left(end) = W_left(1);
end
end

