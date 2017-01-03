function [classifications] = KNNClassify( training_features, test_features, varargin)
    % KNN_CLASSIFICATION performs KNN classification for a k interval and
    % returns the classifications as a result
    % Performs KNN clasification performs knn classification using a set of
    % labeled tarining points and a determines the classes for a set of
    % test points. the training point labels should be the last column of
    % the tarining matrix. 
    % This function accepts the same argumens that are passed to knnsearch
    % note that there is an additional distance method 'neuclidean 'that 
    % performs normalization before normalization using normc before
    % performing the classification using regular 'euclidean'

    p = inputParser;
    % How many neighbours are we considering in this classification

    addParameter(p, 'K', 15);
    addParameter(p, 'KThreshold', false);
    % The minimum number of nearest neighbours that should be MAs
    % to classify current feature as MA
    addParameter(p, 'Distance', 'seuclidean');
    parse(p, varargin{:});
    kvalue = p.Results.K;
    kThreshold = p.Results.KThreshold;
    
    if (kThreshold == false)
       kThreshold = ceil(kvalue/2); 
    end
    
    distance = p.Results.Distance;

    if (size(test_features,2) ~= size(training_features,2)-1)
        error('The sizes of your test features and training features are not compatible: %s. %s, %s %s', ...
              'The size of the test features should be equal to size of training features minus 1. But found test size:', ...
              size(test_features), 'and training size: ', size(training_features) );
    end
    
    % Normalizing the columns before classification because knn search
    % screws up when we use 'seucledian' distance and there are zero
    % columns in the training or the test features
    if (strcmp(distance, 'neuclidean'))
        training_features(:, 1:end-1) = normc(training_features(:, 1:end-1));
        test_features = normc(test_features);
        distance = 'euclidean';
    end
    
    classifications = zeros(size(test_features,1), 1);

    [IDX, D] = knnsearch(training_features(:, 1:end-1), test_features, 'K', kvalue, 'Distance', distance);

    % Finding the minimum distance
    for id=1:size(IDX, 1)
        indeces = IDX(id,:);
        test_labels = training_features(indeces, end);
        positiveCount = length(find(test_labels));

        % If the positives are greater than the threshold
        if ( positiveCount >= kThreshold)
            classifications(id) = true;
        else
            classifications(id) = false;
        end
    end

end
