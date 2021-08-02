function [ sNumber ] = Frq2BassString( instr, f0 )
% This function delivers a suitable string number to the given fundamental
% frequency f0.
% 
% REFERENCES:
%
% INPUT:
%       instr:          instrument to use ('BA', 'GU')
%       f0:          	fundamental frequncy (Hz)
%
% OUTPUT:
%       sNumber:     	bass string number (1-4)
%
% FUNCTION CALLS:
%


%% getting suitable string number for f0

switch instr
    case('BA')
        if f0<Fret_Tone(instr,2,0)
            sNumber = 1;
        elseif f0<Fret_Tone(instr,3,0)
            sNumber = 2;
        elseif f0<Fret_Tone(instr,4,0)
            sNumber = 3;
        else
            sNumber = 4;
        end
    
    case('GU')
        if f0<Fret_Tone(instr,2,0)
            sNumber = 1;
        elseif f0<Fret_Tone(instr,3,0)
            sNumber = 2;
        elseif f0<Fret_Tone(instr,4,0)
            sNumber = 3;
        elseif f0<Fret_Tone(instr,5,0)
            sNumber = 4;
        elseif f0<Fret_Tone(instr,6,0)
            sNumber = 5;
        else
            sNumber = 6;
        end
end
   

end

