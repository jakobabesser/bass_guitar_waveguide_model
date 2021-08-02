function [ matlab_movie ] = PlotAnimation( W_vis, W_left_vis, W_right_vis, FretPos_Plot, FretDistance_Plot, PickupPos_Plot )
% This function creates a matlab movie of the vibrating string.
% 
% REFERENCES:
%
% INPUT:
%       W_vis:              full wave
%       W_left_vis:         left travelling wave
%       W_right_vis:        right travelling wave
%       FretPos_Plot:       fret positions
%       FretDistance_Plot: 	fret distances
%       PickupPos_Plot:     pickup positions
%
% OUTPUT:
%       matlab_movie:    	resulting matlab movie
%
% FUNCTION CALLS:


close all;

%% plot left & right going waves ON/OFF
plot_all = 1;

%% getting size of Input
[size1, size2] = size(W_vis);

%% creating a figure
fig1 = figure(1);
% set(fig1, 'Position', [200 100 768 576]);

%% getting size of window
winsize = get(fig1, 'Position');
winsize(1:2) = [0 0];

%% getting number of frames
numframes = size2;

%% creating matlab movie matrix
matlab_movie = moviein(numframes, fig1, winsize);

%% fixing features of plot window
set(fig1, 'NextPlot','replacechildren');

%% setting loop variable
i = 1;

%% plotting each picture
for j=1:6:numframes
    
    if plot_all == 1
        subplot(3,1,1); plot(W_left_vis(:,j))
        axis([1 size1 -1.5 1.5]);
        title('Left')
        subplot(3,1,2); plot(W_right_vis(:,j))
        axis([1 size1 -1.5 1.5]);
        title('Right')
%         subplot(3,1,3); plot(FretPos_Plot, FretDistance_Plot,'o',
%         1:size1, W_vis(:,j));
        subplot(3,1,3); plot(1:size1, W_vis(:,j));
        axis([1 size1 -1.5 1.5]);
        title('Both')
    else
        plot(FretPos_Plot, FretDistance_Plot,'o',PickupPos_Plot,[-1,-1],'x', 1:size1, W_vis(:,j));
%         plot(1:size1, W_vis(:,j));
        axis([1 size1 -2 2]);
        title('Wave')
    end
    %% saving picture to movie matrix
    matlab_movie(:,i)=getframe(fig1, winsize);
    
    %% incrementing loop variable
    i=i+1;
    
end
end

