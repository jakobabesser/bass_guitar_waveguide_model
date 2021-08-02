function [ f_String, decay_rate, beta, CR ] = GuitarStrParameters( sNumber )
% This function sets the properties of the four different bass strings.
% 
% REFERENCES:
%
% INPUT:
%       sNumber:        string number (1-6)
% 
% OUTPUT:
%       f_String:    	frequency of string (Hz)
%       decay_time:     decay time t60 (seconds)    
%       beta:           filter factor (0-2.5)
%       CR:             reflection factor for first fret contact (0-1)
%
% FUNCTION CALLS:
%


%% switch between strings
switch (sNumber)
    case (1)
        %% setting f0 of string
        f_String = 82.4;
        
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 3;
        
        %% setting filter parameter
        beta = 2;
        
    case (2)
        %% setting f0 of string
        f_String = 110;
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 2.4;
        
        %% setting filter parameter
        beta = 1.5;
        
    case (3)
        %% setting f0 of string
        f_String = 146.8;
        
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 3.75;
        
        %% setting filter parameter
        beta = 0.6; %0.7
        
    case (4)
        %% setting f0 of string
        f_String = 196;
        
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 5.5;
        
        %% setting filter parameter
        beta = 0.05; %0.45
             
    case (5)
        %% setting f0 of string
        f_String = 246.9;
        
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 5.5;
        
        %% setting filter parameter
        beta = 0.05; %0.45
        
    case (6)
        %% setting f0 of string
        f_String = 329.6;
        
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 5.5;
        
        %% setting filter parameter
        beta = 0.05; %0.45
   
end
end
