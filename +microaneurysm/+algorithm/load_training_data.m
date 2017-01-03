function [ features ] = load_training_data( input_dir, training_filenames, variable_name, varargin )
%LOAD_TRAINING_DATA Summary of this function goes here
%   Detailed explanation goes here
    
    p = inputParser();
    addParameter(p, 'prefix', '');
    addParameter(p, 'suffix', '');
    addParameter(p, 'fext', '.mat');
    parse(p, varargin{:});
    
    prefix = p.Results.prefix;
    suffix = p.Results.suffix;
    fext = p.Results.fext;
 
    features = [];
    for i=1:length(training_filenames)
        x = load(strcat(input_dir, prefix, training_filenames{i}, suffix, fext));
        features = [features; x.(variable_name)];
    end
    
end

