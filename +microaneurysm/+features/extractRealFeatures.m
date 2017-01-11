function [realFeatures, isRealFeatures] = extractRealFeatures(featuresAll)
    % Given that some features sometimes compute squareroot of a negative
    % number or something similar, this function will extract only the real
    % valued feature rows from a feature matrix and it returns the set of
    % real features which is a subset of all features, and a logical vector
    % specifying which features were chosen from the set of all features
    realFeatures = zeros(0, size(featuresAll,2));
    isRealFeatures = false(size(featuresAll,1), 1);
    for i=1:size(featuresAll,1)
        if ( isreal(featuresAll(i,:)) )
            realFeatures = [realFeatures; featuresAll(i, :)];
            isRealFeatures(i) = true;
        end
    end
end
