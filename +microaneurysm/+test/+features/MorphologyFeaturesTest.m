classdef MorphologyFeaturesTest < matlab.unittest.TestCase
    %MORPHOLOGYTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Test)
        function testThatTheMorphologyFeaturesCanBeComputed(testCase)
           import microaneurysm.features.morphologyFeatures
           inputImage = rand(50);
           candidatesMask = false(50);
           candidatesMask(4:6, 4:6) = true;
           candidates = microaneurysm.candidates.Candidates();
           candidates.setFromBinaryImage(candidatesMask);
           
           morphologyfeatures = morphologyFeatures(inputImage, candidates);
           testCase.verifyEqual(size(morphologyfeatures), [1, 3]);
           
        end
    end
    
end

