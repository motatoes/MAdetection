classdef (Abstract) BaseException < MException
    % < MException
    %The base exception for micreoaneurysm pacakage
    
    methods
        function obj = BaseException(messageID, identifier, varargin)
          obj = obj@MException(messageID, identifier, varargin{:});
        end
    end
    
end

