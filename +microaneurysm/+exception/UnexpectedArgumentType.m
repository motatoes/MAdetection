classdef UnexpectedArgumentType < microaneurysm.exception.BaseException
    %UNEXPECTEDARGUMENTTYPE Summary of this class goes here
    
    methods
        
        function obj = UnexpectedArgumentType(expectedType, actualType, varargin)
          obj = obj@microaneurysm.exception.BaseException('microaneurysm:exceptions:UnexpectedArgumentType', ...
                                sprintf('Unexpected type, expected: %s \n but the type was: %s', expectedType, actualType), ...
                                varargin{:});
        end
    end
    
end

