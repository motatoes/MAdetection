function [ rocscore ] = rocScore( averageFalsePositives, sensitivities )
%ROCSCORE Summary of this function goes here

    [~, idx] = sort(averageFalsePositives);
    averageFalsePositives = averageFalsePositives(idx);
    [~, idx]= unique(averageFalsePositives);
    averageFalsePositives = unique(averageFalsePositives);
    averageFalsePositives = averageFalsePositives(idx);
    sensitivities = sensitivities(idx);
    rocscore = mean(interp1(averageFalsePositives, sensitivities, [1/8, 1/4, 1/2, 1, 2, 4, 8]));

