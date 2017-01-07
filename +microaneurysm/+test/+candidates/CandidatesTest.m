classdef CandidatesTest < matlab.unittest.TestCase
    
    %CANDIDATESTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    
    methods(Test)
        
        function testThatCandidatesCanBeSetFromBinaryImage(testCase)
            import microaneurysm.candidates.Candidates            
            binaryimg = false( 5 );
            binaryimg(2:4, 2:4) = 1;
            c = Candidates();
            c.setFromBinaryImage(binaryimg)
            carr = c.getCellArray();
            testCase.verifyEqual( carr{1}, [ 7, 8, 9, 12, 13, 14, 17, 18, 19 ]' );
            testCase.verifyEqual( c.getBinaryImage, binaryimg );
        end
        
        function testThatCandidatesCanBeSetFromCellArray(testCase)
            import microaneurysm.candidates.Candidates
            cellarr = { [7, 8, 9, 12, 13, 14, 17, 18, 19 ]'};
            binaryimg = false(5);
            binaryimg(2:4, 2:4) = 1;
            c = Candidates();
            c.setFromCellArray(cellarr, [5 5]);
            testCase.verifyEqual( c.getBinaryImage(), binaryimg);
            testCase.verifyEqual( c.getCellArray(),  cellarr);
        end
        
        function testThatCadidateCanBeSetFromBinaryImageWith2Objects(testCase)
           import microaneurysm.candidates.Candidates
           binaryimg = false(5);
           binaryimg(1) = 1;
           binaryimg(3) = 1;
           c = Candidates();
           c.setFromBinaryImage( binaryimg );           
           cellarr = c.getCellArray();
           testCase.verifyEqual( cellarr{1}, [1] );
           testCase.verifyEqual( cellarr{2}, [3] );
           testCase.verifyEqual( c.getBinaryImage(), binaryimg);
        end
        
        
        function testThatCandidateCanBeSetFromCellArrayWith2Objects(testCase)
            import microaneurysm.candidates.Candidates
            cellarr = {[1] [3]};
            binaryimg = false(5);
            binaryimg(1) = 1;
            binaryimg(3) = 1;
            c = Candidates();
            c.setFromCellArray( cellarr, [5 5] );
            testCase.verifyEqual( c.getBinaryImage(), binaryimg );
            testCase.verifyEqual( c.getCellArray(), cellarr);
        end
        
        function testTheCandidatesToSeedLocationsFunction(testCase)
            import microaneurysm.candidates.Candidates
            import microaneurysm.candidates.candidatesToSeedLocations
                                            
            inputImage = ones(5);
            inputImage(1) = 0;
            cellarr = {[1 3]};
            c = Candidates();
            c.setFromCellArray( cellarr, [5 5] );
            seedlocs = microaneurysm.candidates.candidatesToSeedLocations(inputImage, c);
            testCase.verifyEqual(seedlocs, {1});
        end
        
        function testCandidatesForEachFunctiton(testCase)
            import microaneurysm.candidates.Candidates
            cellarr = {[1]; [3]};
            c = Candidates();
            c.setFromCellArray( cellarr, [5 5] );
            res = c.foreach(@(ca) ca);
            testCase.verifyEqual(res, cellarr);
        end
        
        function testLabelCandidatesFn( testCase )
           import microaneurysm.candidates.Candidates
           import microaneurysm.candidates.labelCandidates
           
           binaryimg = false(5);
           binaryimg(1) = 1;
           binaryimg(3) = 1;
           c = Candidates();
           c.setFromBinaryImage( binaryimg );
           groundtruth = binaryimg;
           labels = labelCandidates(c, groundtruth);
           
           testCase.verifyEqual(labels, [1; 1]);
           
        end
        
        function testCandidatesFilterFunction( testCase )
            import microaneurysm.candidates.Candidates
            
            ca = {[5], [9, 10], [22]};
            c = Candidates();
            c.setFromCellArray(ca, [50,50]);
            c = c.filter([1 0 1]);
            testCase.verifyEqual(numel(c.getCellArray()), 2); 
            
        end
        
    end
    
end
