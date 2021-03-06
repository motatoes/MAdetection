function [ training_features_undersampled ] = training_undersampling( training_features )
%TRAINING_UNDERSAMPLING Performs undersampling of the training data in
% order to have the resulting data 

    % The classification column is the last column in the tarining feature matrix
    training_isMA = training_features(:, end);
    
    % A mask that will filter out the features that will stay from the
    % nonMA features (the ones that have a class of 0)
    staying_nonMAs = zeros( size(training_features, 1), 1 );
    MA_count = length(find(training_isMA));
    total_count = length(training_isMA);
    while ( MA_count > length(find(staying_nonMAs)))
        idx = floor(rand() * total_count)+1;
        if ( training_isMA(idx) == 0)
            staying_nonMAs(idx) = 1;
        end
    end

    staying_values = training_isMA | staying_nonMAs;

    
    training_features_undersampled = training_features(staying_values, :);

end

