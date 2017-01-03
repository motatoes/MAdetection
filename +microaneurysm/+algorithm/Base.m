classdef (Abstract) Base < handle
    
    properties
    end
    
    methods(Abstract)
        % candidates is an object of type
        % microaneurysm.candidates.candidates
        % intermediateResults is a cell array containing all the
        % intermediate results of the computation
        [candidates, intermediateResults] = apply(self);
    end
    
    methods
    end
    
end
