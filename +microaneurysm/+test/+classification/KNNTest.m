classdef KNNTest < matlab.unittest.TestCase
    %KNNTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Test)
        function testThatKNNclassificationWorks(testCase)
           import microaneurysm.classification.KNNClassify
           
           trainingFeatures = rand(10,10);
           trainingFeatures(:,end) = trainingFeatures(:, end) > 0.5;
           testFeatures = rand(19,9);
           labels = KNNClassify(trainingFeatures, testFeatures);
           testCase.verifyEqual(size(labels), [19, 1] );
           
        end
        
        function testKNNclassificationWithCustomThreshold(testCase)            
           import microaneurysm.classification.KNNClassify
           
           trainingFeatures = rand(10,10);
           trainingFeatures(:,end) = trainingFeatures(:, end) > 0.5;
           testFeatures = rand(19,9);
           labels = KNNClassify(trainingFeatures, testFeatures, 'KThreshold', 4);
           testCase.verifyEqual(size(labels), [19, 1] );
        end
        
        function testKNNclassifierWithCustomKvalue(testCase)
           import microaneurysm.classification.KNNClassify
           
           trainingFeatures = rand(10,10);
           trainingFeatures(:,end) = trainingFeatures(:, end) > 0.5;
           testFeatures = rand(19,9);
           labels = KNNClassify(trainingFeatures, testFeatures, 'K', 7);
           testCase.verifyEqual(size(labels), [19, 1] );
        end            
        
    end
    
end

