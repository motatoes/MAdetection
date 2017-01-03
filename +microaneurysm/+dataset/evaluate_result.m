function [ TP, FP, result_img ] = evaluate_result( classifications, seedLocations, GT_image )
%EVALUATE_RESULT Summary of this function goes here
%   Detailed explanation goes here
        
    result_img = false(size(GT_image));
    TP = 0;
    FP = 0;
    
    for j=1:length(seedLocations)
        % We do it only for the pixels that were classified during the
        % classification phase
        if (classifications(j) == 1)

        % Append the result to the resulting classified image
        result_img(seedLocations{j}) = 1;

        % Just check if the seed point lies on an rgmask or not
        % to decide if its an MA or no
            if ( GT_image( seedLocations{j} ) == 1 )
                TP = TP + 1;
            else
                FP = FP + 1;
            end
        end
    end

end

