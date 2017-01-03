classdef Paraboloid < handle
        
    properties(GetAccess=public, SetAccess=private)
        % implemnts the paraboloid equation in (Fleming, 2006)
        % This parameter is an array vector of Ai (for i=[1..6])
       A;
    end
    
    methods
        
        function obj = Paraboloid(Aparams, varargin)
            obj.setParaboloidParameters(Aparams);
        end

        function [aMinor, aMajor] = getMajorMinorAxis( self, zmean, varargin )
        %GET_AMINORAXIS Summary of this function goes here
        %   Detailed explanation goes here
            
            p = inputParser();
            addParameter(p, 'uplus', false);
            addParameter(p, 'uminus', false);
            parse(p, varargin{:});
            uplus = p.Results.uplus;
            uminus = p.Results.uminus;
            
            if (uplus == false || uminus == false)
                [uplus, uminus] = self.getUPlusMinus();
            end
            
            A = self.A;
            
            if (uminus == 0)
               warning('The value of uminus is zero and therefore aminor and amajor axis will be infinity'); 
            end
            
            % Vectorising this part ..
            tmp1 = (zmean - A(6)) ./ uplus;
            tmp2 = (zmean - A(6)) ./ uminus;
            
            aMinor = 2 * sqrt( tmp1 );            
            aMajor = 2 * sqrt( tmp2 ); 
        end
        
        function [depths] = getDepth(self, zmean, varargin)
            % Calculating the candidate MA depths which are needed to
            % calculate some of the features
            A = self.A;
            depths = zmean - A(6);
        end
        
%         function [zmeans] = get_zmeans(self, rgBoundaryPixels)
%             % Calculating the zmeans values which are the mean intensity
%             % around (in the preprocessed image)
%             S = self.intensityImage;
%             
%             zmeans = zeros(length(rgBoundaryPixels), 1);
%             for i=1:length(rgBoundaryPixels)
%                 
%                 % Get the boundary pixels around the MA candidate
%                 boundaryPixels = rgBoundaryPixels{i};
% 
%                 % The following line is to avoid out of bounds exception while 
%                 % running the code but is this the right thing to do???????
%                 if (isempty(boundaryPixels))
%                     continue;
%                 end
%                 
%                 % The zmeans is the average intensity value around the
%                 % candidate microaneurysm
%                 zmeans(i) = mean(S(boundaryPixels));
%             end
%         end
%         

        function [z] = getZ(self, x, y)
            A = self.A;
            z = A(3) * (x - A(1))^2 + ...
                2 * A(4) * (x - A(1)) * (y - A(2)) + ...
                A(5) * (y - A(2)) ^ 2 + A(6); 
        end
        
        % == getters == %
        function [uplus, uminus] = getUPlusMinus(self)
            A = self.A;
            sterm = ( A(3) - A(5) ) ^ 2  + 4 * A(4)^2;
            
            if (sterm < 0)
               warning('Negative square root found and the values of uplus and uminus will therefore be complex'); 
            end
            uplus = ( A(3) + A(5) + sqrt(sterm) )/ 2;
            uminus = ( A(3) + A(5) - sqrt(sterm) )/ 2;
        end
                
        % == setters == %
        function setParaboloidParameters(self, newA)
            if (ndims(newA) ~= 2)
                throw(microaneurysm.exception.InvalidArgument(sprintf('newA. expected ndims to be 2, instead was %d', ndims(newA))));
            end
            if ( size(newA,1) ~= 1 || size(newA,2) ~= 6)
                throw(microaneurysm.exception.InvalidArgument(sprintf( 'newA. expected the size to be [1, 6], instead was [%d %d]', size(newA,1), size(newA,2)) ));
            end
            self.A = newA;
        end
    end
        
end