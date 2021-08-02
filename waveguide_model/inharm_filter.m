function [ W_left, W_right, inharm_buffer, inharm_buffer_filled ] = inharm_filter( W_left, W_right, FilterPos, length_fact, inharmCoeff, m, length_W, inharm_buffer, inharm_buffer_filled, g)
% This function filters the left and right travelling waves at a specific
% point in the digital delay line to simulate the inharmonicity caused by the
% string stiffness, bridge and nut.
% 
% REFERENCES:
%
% INPUT:
%       W_left:        	travelling wave to the left
%       W_right:      	travelling wave to the right
%       FilterPos:     	filter position in the delay line
%       length_fact:    length factor
%       inharmCoeff:       filter coefficients of loss filter
%       m:              left wave pointer
%       length_W:       length of waves
%
% OUTPUT:
%       W_left:        	travelling wave to the left
%       W_right:      	travelling wave to the right
%
% FUNCTION CALLS:
%


%% get coefficents
for filterStage = 1:size(inharmCoeff)

    b0 = 1-g*(1-inharmCoeff(filterStage, 1));
    b1 = 1-g*(1-inharmCoeff(filterStage, 2));
    b2 = 1-g*(1-inharmCoeff(filterStage, 3));
    %a0 = inharmCoeff(filterStage, 4);
    a1 = 1-g*(1-inharmCoeff(filterStage, 5));
    a2 = 1-g*(1-inharmCoeff(filterStage, 6));
%     b0 = 1;
%     b1 = 1;
%     b2 = 1;
%     a0 = 1;
%     a1 = 1;
%     a2 = 1;
%      FilterPos = FilterPos - filterStage;

%     if (~inharm_buffer_filled(filterStage))
%         inharm_buffer(1,filterStage) = W_left( mod(ceil((FilterPos+m)-3), length_W)+1);
%         inharm_buffer(2,filterStage) = W_left( mod(ceil((FilterPos+m)-2), length_W)+1);
%         inharm_buffer(3,filterStage) = W_left( mod(ceil((FilterPos+m)-1), length_W)+1);
%         inharm_buffer_filled(filterStage) = 1;
%     end
    
    %% getting left & right travelling wave state at filter position
    LF_leftPos = ceil((FilterPos+m));%*length_fact
    LF_leftWave = W_left(mod(LF_leftPos, length_W)+1);

    %% getting next filter positon
    LF_leftPos_next = floor((FilterPos+m+1)); %*length_fact

    %% getting all values between the two filter positions
    if LF_leftPos_next == LF_leftPos
        LF_leftWave_all = LF_leftWave;
    else
        LF_leftWave_all = W_left(mod(LF_leftPos:1:LF_leftPos_next-1, length_W)+1);
    end

    %% getting new filtered values
    for loop = 0:length(LF_leftWave_all)-1
        %% filtering value with filter coefficients
        inharm_buffer(3, filterStage) = inharm_buffer(2, filterStage);
        inharm_buffer(2, filterStage) = inharm_buffer(1, filterStage);

        inharm_buffer(1, filterStage) = W_left( mod((LF_leftPos+loop), length_W)+1) ...
                                        + (-a1)*inharm_buffer(2, filterStage) ...
                                        + (-a2)*inharm_buffer(3, filterStage);
        bridge = b0 * inharm_buffer(1, filterStage) + ...
                 b1 * inharm_buffer(2, filterStage) + ...
                 b2 * inharm_buffer(3, filterStage);

        %% writing new value back to traveling waves 
%          if (inharm_buffer_filled(filterStage) >= 1)
            W_left(mod(LF_leftPos+loop, length_W)+1) = bridge;
            W_right((mod(length_W-LF_leftPos+loop, length_W)+1)) = -bridge;
%          else
%             inharm_buffer_filled(filterStage) = inharm_buffer_filled(filterStage)+1;
%          end
        %% setting last value equal to first one
        %W_right(end) = W_right(1);
        %W_left(end) = W_left(1);
    end
end
end

