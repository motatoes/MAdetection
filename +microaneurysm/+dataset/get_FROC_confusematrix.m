function [TP, FP, FN] = get_FROC_confusematrix(predictions, labels, varargin)
    %GET_FROC_CONFUSMATRIX this function gets the result of the confusion
    %matrix provided one or more classifications along with their labels
    % CLASSIFICATIONS is a matrix that contains one or more prediction
    % results , where each column in CLASSIFICATIONS is a prediction result
    %
    % LABELS, is the groundtruth result, a row vector with the same number
    % of rows as PREDICTIONS
    %
    %
    % create the evaluation matrix of TP and FPs
    
    p = inputParser;
    addParameter( p, 'gtcount', length(find(labels)) );
    parse(p, varargin{:});
    gtcount = p.Results.gtcount;
    npredictions = size(predictions, 2);
    
    if (size(predictions,1) ~= size(labels,1))
        error('The predictions matrix and the labels vector do not have the same size');
    end
    
    TP = zeros(1, npredictions);
    FP = zeros(1, npredictions);
    FN = zeros(1, npredictions);

    % == Performing the evaluation of the result == %
    for kmt=1:npredictions
        
        TP(kmt) = length(find(predictions(:, kmt) & labels ));
        FP(kmt) = length(find(predictions(:, kmt) & ~labels ));
    
        % The false negatives are the ones detected by algo. as non-MAs
        % when in   
        % fact they were. So we subtract the correctly detected MAs from the total "true MAs"
        % To get this value ... think about it 
        FN(kmt) = (gtcount - TP(kmt));
    end


end