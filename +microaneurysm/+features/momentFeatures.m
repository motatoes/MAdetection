function [ features ] = momentFeatures( candidates )
%CALCULATESIZEFEATURES2 Summary of this function goes here
%   Detailed explanation goes here
    import microaneurysm.features.invmoments
    import microaneurysm.util.imcropCenter
    
    rgPixels = candidates.getCellArray();
    imageSize = size( candidates.getBinaryImage );
    
    features = zeros(length(rgPixels), 7);
    for i=1:length(rgPixels)
        
        rgim = zeros(imageSize);
        rgim(rgPixels{i}) = 1;
        
        % Moments
        seedloc = rgPixels{i};
        seedloc = seedloc(1);
        [rr,cc] = ind2sub(imageSize, rgPixels{i});
        rr = rr - min(rr) + 1;
        cc = cc - min(cc) + 1;
        
        [rrind] = sub2ind( [max(rr), max(cc)], rr, cc);
        xx = false(max(rr), max(cc));
        xx(rrind) = 1;
        
        features(i,1:7) = invmoments( xx );
    end
    
end
