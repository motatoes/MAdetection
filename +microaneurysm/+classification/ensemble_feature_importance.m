function [ feature_importance ] = ensemble_feature_importance( training_features, varargin )
    %ENSEMBLE_FEATURE_IMPORTANCE Summary of this function goes here
    %   Detailed explanation goes here

    p = inputParser();
    addParameter(p, 'numTrees', 100);
    parse(p, varargin{:});

    numTrees = p.Results.numTrees;

    training_features_noclasses = training_features(:, 1:end-1);
    groups = training_features(:, end);
    ensType = 'Bag';


    ensABM1 = fitensemble(training_features_noclasses, groups, ensType, ...
                          numTrees, 'Tree', ...
                          'type', 'classification', ...
                          'nprint', 5);

    tb_ves = TreeBagger(100, training_features_noclasses, groups, ...
                        'method', 'c', ...
                        'oobpred', 'on', ...
                        'oobvarimp', 'on', ...
                        'nprint', 2);

    disp('calculation evalution ... ');
    ensQuality.rslossE = resubLoss(ensABM1, 'mode', 'cumulative');
    ensQuality.rsedgeE = resubEdge(ensABM1, 'mode', 'ensemble');
    ensQuality.rsmargin = resubMargin(ensABM1);
    [ensQuality.rsplabel, ensQuality.rsScore] = resubPredict(ensABM1);
    [ensQuality.pIimp, ensQuality.pIma] = predictorImportance(ensABM1);

    % Return the feature importance value
    feature_importance = ensQuality.pIimp;

end