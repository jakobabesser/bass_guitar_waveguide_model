function [ f_String, decay_rate, beta, CR ] = BassStrParameters( sNumber )
% This function sets the properties of the four different bass strings.
% 
% REFERENCES:
%
% INPUT:
%       sNumber:        string number (1-4)
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
        f_String = 41.2;
        
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 3;
        
        %% setting filter parameter
        beta = 2;
        
    case (2)
        %% setting f0 of string
        f_String = 55;
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 2.4;
        
        %% setting filter parameter
        beta = 1.1;
        
    case (3)
        %% setting f0 of string
        f_String = 73.4;
        
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 3.75;
        
        %% setting filter parameter
        beta = 0.7; %0.7
        
    case (4)
        %% setting f0 of string
        f_String = 98;
        
        %% setting reflection factor of frets
        CR=1;
        
        %% setting decay rate in dB/s
        decay_rate = 3;
        
        %% setting filter parameter
        beta = 0.5; %0.45
        
end
end