function [ W_left, W_right, first_hit, hit_time, FretValue_last_sample] = Fret_Collision( FretPos, FretDistance, FretIndex, m, W_left, W_right, length_fact, CR , t, first_hit, hit_time, FretValue_last_sample, deflection)
% This function controls if the wave of a waveguide model collides with an
% object (like a fret for example).
% 
% REFERENCES:
%
% "Player-Instrument Interaction Models for Digital Waveguide Synthesis of 
% Guitar Touch and Collisions" by Gianpaolo Evangelista and Fredrik 
% Eckerholm, 2010
%
% INPUT:
%       FretPos:                fret positions in the delay line
%       FretDistance:           fret distances
%       FretIndex:              currently used fret for given string and f0
%       m:                      wave pointer
%       W_left:                 travelling wave to the left
%       W_right:                travelling wave to the right
%       length_fact:            length factor
%       excitation:             excitation type of waveguide model
%       CR:                     reflection factor for first collision
%       t:                      time sample
%       first_hit:              memory for the first collisions
%       hit_time:               first collision times
%       FretValue_last_sample:  saved old value
%       deflection:             deflection of excitation signal
%
% OUTPUT:
%       W_left:                 travelling wave to the left
%       W_right:                travelling wave to the right
%       first_hit:              memory for the first collisions
%       hit_time:               first collision times
%       FretValue_last_sample:  saved old value
%
% FUNCTION CALLS:
%


%% getting length of waves
length_W = length(W_left);

%% creating scattering matrix
Sc=1/2*[1, -1; -1, 1];
% Sc=[0, -1; -1, 0];

%% going through all fret positions
for x=FretIndex+1:length(FretPos)-1
    %% getting left & right travelling wave state at fret position
    Fret_rightMod = round((FretPos(x)-m)*length_fact);
    Fret_leftMod = round((FretPos(x)+m)*length_fact);
    Fret_rightWave = W_right(mod(Fret_rightMod, length_W)+1);
    Fret_leftWave = W_left(mod(Fret_leftMod, length_W)+1);
    
    %% testing if fret is touched
    if (Fret_rightWave+Fret_leftWave) <= -FretDistance(x)
        %% testing for first contact
        if first_hit(x) == 0
            %% saving first contact
            hit_time(x) = t;
            first_hit(x) = 1;
        end
        %% getting next positon for this fret
        Fret_rightMod_next = round((FretPos(x)-m-1)*length_fact);
        Fret_leftMod_next = round((FretPos(x)+m+1)*length_fact);
        
        %% getting all values between the two positions
        if Fret_rightMod_next == Fret_rightMod
            Fret_rightWave_all = Fret_rightWave;
        else
            Fret_rightWave_all = W_right(mod(Fret_rightMod_next+1:1:Fret_rightMod, length_W)+1);
        end
        if Fret_leftMod_next == Fret_leftMod
            Fret_leftWave_all = Fret_leftWave;
        else
            Fret_leftWave_all = W_left(mod(Fret_leftMod:1:Fret_leftMod_next-1, length_W)+1);
        end
        %% setting up the offset value for first hit
        vin = ((Fret_rightWave+Fret_leftWave)-FretValue_last_sample(x))/(1/44100);
        u_ofs = CR*deflection;
        if sign(vin) == 1 || (t-hit_time(x)) >= 1
            u_ofs = 0;
        end
        
        %% calculating reference value
        Uref = -FretDistance(x) +u_ofs;
        
        %% averaging values of right & left travelling wave
        Uin_right = sum(Fret_rightWave_all)/length(Fret_rightWave_all);
        Uin_left = sum(Fret_leftWave_all)/length(Fret_leftWave_all);
        
        %% calculating new values
        Uout = Sc*[Uin_right; Uin_left]+Uref/2*[1; 1];
        
        %% saving the old value
        FretValue_last_sample(x)=Fret_rightWave+Fret_leftWave;
        
        %% writing new values back to the delay line
        W_left(mod((Fret_leftMod:1:Fret_leftMod_next-1), length_W)+1) = Uout(2);
        W_right(mod((Fret_rightMod_next+1:1:Fret_rightMod), length_W)+1) = Uout(1);
                
        W_right(mod((length_W-(Fret_leftMod_next-1):1:length_W-Fret_leftMod), length_W)+1) = -Uout(2);
        W_left(mod((length_W-Fret_rightMod:1:length_W-(Fret_rightMod_next+1)), length_W)+1) = -Uout(1);
                
    else
        %% saving the old value
        FretValue_last_sample(x)=Fret_rightWave+Fret_leftWave;
%         first_hit(x) = 0;
    end   
end
%% setting last value equal to first one
W_right(end) = W_right(1);
W_left(end) = W_left(1);

end