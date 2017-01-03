classdef InvalidArgument < microaneurysm.exception.BaseException
    %INVALIDARGUMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = InvalidArgument(argumentName, varargin)
          obj = obj@microaneurysm.exception.BaseException('microaneurysm:exceptions:invalidArgument', ...
                                sprintf('An invalid argument was passed into the function. Argument: %s', argumentName), ...
                                varargin{:});
        end
    end
    
end

