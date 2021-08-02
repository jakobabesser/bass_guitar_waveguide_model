function [ bandwidths ] = TEST_bandwidth_for_f0( )
%TEST_BANDWIDTH_FOR_F0 Summary of this function goes here
%   Detailed explanation goes here

InharmBetasMat = load('InharmBetas.mat', 'InharmBetas');
inharmBetas = InharmBetasMat.InharmBetas;

for string = 1:4
    for fret = 0:12
        if inharmBetas(string, fret+1)~=0
            for  bw=20000:-100:500
                if (size(adf(2*Fret_Tone('BA', string, fret),inharmBetas(string, fret+1),bw,0.85))<=10)
                    bandwidths(string, fret+1) = bw;
                    break;
                end
            end
        else
            bandwidths(string, fret+1) = 0;
        end
    end
end

save 'inharmfilter_bandwidths.mat' bandwidths
end