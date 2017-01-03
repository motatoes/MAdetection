function [ classifications ] = ensemble_classification_fromModel( ensembleModel, test_features, varargin )
%ENSEMBLE_CLASSIFICATION_FROMMODEL Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser();
    addParameter(p, 'probabilityInterval', 0.05);
    parse(p, varargin{:});
    
    probabilityInterval = p.Results.probabilityInterval;

    probabilityRange = 0:probabilityInterval:1;
    [ypredicted, yprobmap] = predict(ensembleModel, test_features);
    
    classifications = zeros( length(probabilityRange), length(ypredicted) );

    for i = 1:length(probabilityRange)
        p = probabilityRange(i);
        classifications(i,:) = yprobmap(:,2)' > p;
    end

end