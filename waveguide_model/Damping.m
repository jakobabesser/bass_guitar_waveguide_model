function [ W_left, W_right ] = Damping( DampPos, m, W_left, W_right, length_fact, Z1, Z2, Z3, Damp_Width, length_W)
% This function damps the wave of a waveguide model at a specific
% point in the delay line.
% 
% REFERENCES:
%
% "Physical modeling of flageolet tones in string instruments" by Jyri
% Pakarinen, 2005
% 
% INPUT:
%       DampPos:       	damping position in the delay line
%       m:              wave pointer
%       W_left:        	travelling wave to the left
%       W_right:      	travelling wave to the right
%       length_fact:    length factor
%       Z1, Z2, Z3:     port impedances
%       Damp_Width:     width of damping point
%       length_W:       length of waves
%
% OUTPUT:
%       W_left:        	travelling wave to the left
%       W_right:      	travelling wave to the right
%
% FUNCTION CALLS:
%


%% calculating scattering factors
p1 = (Z1-Z2-Z3)/(Z1+Z2+Z3);
p2 = (2*Z2)/(Z1+Z2+Z3);
p3 = (2*Z1)/(Z1+Z2+Z3);
p4 = (Z2-Z1-Z3)/(Z1+Z2+Z3);

%% getting left & right travelling wave state at damp position
Damp_rightPos = round((DampPos-m)*length_fact);
Damp_leftPos = round((DampPos+m)*length_fact);
Damp_rightWave = W_right(mod(Damp_rightPos, length_W)+1);
Damp_leftWave = W_left(mod(Damp_leftPos, length_W)+1);
    
%% getting next damp positon
Damp_rightPos_next = round((DampPos-m-1)*length_fact)-Damp_Width;
Damp_leftPos_next = round((DampPos+m+1)*length_fact)+Damp_Width;

%% getting all values between the two damp positions
if Damp_rightPos_next == Damp_rightPos
	Damp_rightWave_all = Damp_rightWave;
else
	Damp_rightWave_all = W_right(mod(Damp_rightPos_next+1:1:Damp_rightPos, length_W)+1);
end

if Damp_leftPos_next == Damp_leftPos
	Damp_leftWave_all = Damp_leftWave;
else
	Damp_leftWave_all = W_left(mod(Damp_leftPos:1:Damp_leftPos_next-1, length_W)+1);
end

%% getting number of values
num_Value_r = length(Damp_rightWave_all);
num_Value_l = length(Damp_leftWave_all);

%% filling missing values
if num_Value_r > num_Value_l
    num_Value_end = num_Value_r;
    miss_value = W_left(mod(Damp_leftPos_next, length_W)+1);
%     miss_value = Damp_leftWave_all(end);
    Damp_leftWave_all = [Damp_leftWave_all miss_value];
elseif num_Value_r < num_Value_l
    num_Value_end = num_Value_l;
    miss_value = W_right(mod(Damp_rightPos_next, length_W)+1);
%     miss_value = Damp_rightWave_all(1);
    Damp_rightWave_all = [miss_value Damp_rightWave_all];
else
    num_Value_end = num_Value_r;
end

%% calculating new damped values
for loop = 0:num_Value_end-1
    %% getting current value pair
    a1 = Damp_rightWave_all(end-loop);
    a2 = Damp_leftWave_all(loop+1);

    %% calculating new value pair
    b = [p1, p2; p3, p4]*[a1;a2];
    
    %% writing values back to the delay line
    if num_Value_l >= loop+1
        W_left(mod(Damp_leftPos+loop, length_W)+1) = b(1);
        W_right(mod(length_W-Damp_leftPos-loop, length_W)+1) = -b(1);
    end
    if num_Value_r >= loop+1
        W_right(mod((Damp_rightPos_next+1)+loop, length_W)+1) = b(2);
        W_left(mod(length_W-(Damp_rightPos_next+1)-loop, length_W)+1) = -b(2);
    end
    
end
%% setting last value equal to first one
W_right(end) = W_right(1);
W_left(end) = W_left(1);

end