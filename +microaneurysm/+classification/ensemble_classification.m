function classifications = ensemble_classification(training_features, test_features, varargin)
    %% ensemble_classification: Enter the function description here

    training_features_nolabels = training_features(:, 1:end-1);

    % Check that the sizes are compatible 
    if (size(training_features_nolabels,2) ~= size(test_features, 2))
        error('The sizes of the test features and the training features are not compatible');
    end

    p = inputParser();
    addParameter(p, 'probabilityInterval', 0.01);
    addParameter(p, 'nTrees', 25);
    parse(p, varargin{:});
    
    probabilityInterval = p.Results.probabilityInterval;
    nTrees = p.Results.nTrees;
    ensembleModel = p.Results.ensembleModel;
    ensType = 'Bag';
    
    probabilityRange = 0:probabilityInterval:1;
    
    groups = training_features(:,end);
    

    ensembleModel = fitensemble(training_features_nolabels, groups, ensType, ...
                          nTrees, 'Tree', ...
                          'type', 'classification', ...
                          'nprint', 5);        
    
                      
    classifications = classificationsensemble_classicficiation_fromModel(ensembleModel, test_features, 'probabilityInterval', probabilityInterval);
    
end