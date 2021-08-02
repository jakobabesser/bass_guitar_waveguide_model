function [ timing ] = Note_TapTiming( num_notes )
% This function creates the timing for a group of notes by the key pressing
% speed of the user.
% 
% REFERENCES:
%
% INPUT:
%       num_notes:    	number of notes
%
% OUTPUT:
%       timing:       	resulting timing for note
%
% FUNCTION CALLS:
%


%% waiting for button
fprintf('Press button to start timing for %i notes!\n', num_notes);
pause;

%% creating variable
timing = zeros(1, num_notes);

%% getting note times by tapping a button
for loop = 1:num_notes
    tic;
    fprintf('Timing for note Nr.%i is running\n', loop);
    pause;
    time = toc;
    timing(loop) = time;
end

end