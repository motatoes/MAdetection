function [FP_cummulaive_average, sensetivities] = get_FROC_data( varargin )
%GET_ROC_DATA Summary of this function goes here
%   Detailed explanation goes here
    p = inputParser();
    addParameter(p, 'evalFilesPrefix', '');
    addParameter(p, 'evalFilesSuffix', '');
    addParameter(p, 'inputDir', false);
    addParameter(p, 'testFiles', false);
    addParameter(p, 'TPvariableName', 'TP');
    addParameter(p, 'FPvariableName', 'FP');
    addParameter(p, 'FNvariableName', 'FN');
    parse(p, varargin{:});
    
    % The following variables are loaded as a result of the call to 'settings':
    classifications_matrixprefix = p.Results.evalFilesPrefix;
    classifications_matrixsuffix = p.Results.evalFilesSuffix;
    classifications_folder = p.Results.inputDir;
    imagenames = p.Results.testFiles;
    TPvariableName = p.Results.TPvariableName;
    FPvariableName = p.Results.FPvariableName;
    FNvariableName = p.Results.FNvariableName;
    
    classification_matfiles = {};
    %=================
    
    for i=1:length(imagenames)
        classification_matfiles{i} = strcat(classifications_folder, '\', classifications_matrixprefix, imagenames{i}, classifications_matrixsuffix, '.mat');
    end
    
    % temprorary load  To get the size of the final cummulative
    % confustion matrices and initialize them with zeros
    x = load( classification_matfiles{1});
    tmp = x.(TPvariableName);
    TP_cummulative = zeros(size(tmp));
    FP_cummulative = zeros(size(tmp));
    FN_cummulative = zeros(size(tmp));

    for i=1:length(classification_matfiles)
        x = load( classification_matfiles{i});
        TP = x.(TPvariableName);
        FP = x.(FPvariableName);
        FN = x.(FNvariableName);

        TP_cummulative = TP + TP_cummulative;
        FP_cummulative = FP + FP_cummulative;
        FN_cummulative = FN + FN_cummulative;
    end

    FP_cummulaive_average = FP_cummulative / length(imagenames);

    sensetivities = TP_cummulative ./ (TP_cummulative + FN_cummulative);

end

