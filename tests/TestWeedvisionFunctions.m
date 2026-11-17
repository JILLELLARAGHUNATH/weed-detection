classdef TestWeedvisionFunctions < matlab.unittest.TestCase
    %TESTWEEDVISIONFUNCTIONS Unit tests for the modular image pipeline.
    % Run from the repository root with:
    %   results = runtests('tests/TestWeedvisionFunctions.m');

    properties
        CodeFolder
        TempFolder
    end

    methods (TestMethodSetup)
        function configurePaths(testCase)
            testFolder = fileparts(mfilename('fullpath'));
            repositoryRoot = fileparts(testFolder);
            testCase.CodeFolder = fullfile(repositoryRoot, ...
                'weed detection in crops', 'Code');
            addpath(testCase.CodeFolder);

            testCase.TempFolder = tempname;
            mkdir(testCase.TempFolder);
        end
    end

    methods (TestMethodTeardown)
        function cleanup(testCase)
            rmpath(testCase.CodeFolder);
            if isfolder(testCase.TempFolder)
                rmdir(testCase.TempFolder, 's');
            end
        end
    end

    methods (Test)
        function readsRgbImageAsUint8(testCase)
            sample = uint8(zeros(24, 32, 3));
            sample(:, :, 2) = 180;
            inputPath = fullfile(testCase.TempFolder, 'rgb.png');
            imwrite(sample, inputPath);

            actual = weedvision.readImage(inputPath);

            testCase.verifySize(actual, [24 32 3]);
            testCase.verifyClass(actual, 'uint8');
            testCase.verifyEqual(actual, sample);
        end

        function expandsGrayscaleImageToRgb(testCase)
            sample = uint8(reshape(1:100, 10, 10));
            inputPath = fullfile(testCase.TempFolder, 'gray.png');
            imwrite(sample, inputPath);

            actual = weedvision.readImage(inputPath);

            testCase.verifySize(actual, [10 10 3]);
            testCase.verifyEqual(actual(:, :, 1), sample);
            testCase.verifyEqual(actual(:, :, 2), sample);
            testCase.verifyEqual(actual(:, :, 3), sample);
        end

        function errorsForMissingImage(testCase)
            missingPath = fullfile(testCase.TempFolder, 'missing.png');
            testCase.verifyError(@() weedvision.readImage(missingPath), ...
                'weedvision:FileNotFound');
        end

        function extractsFiniteExgImages(testCase)
            sample = zeros(32, 32, 3, 'uint8');
            sample(:, :, 1) = 90;
            sample(:, :, 2) = 150;
            sample(:, :, 3) = 70;
            sample(9:24, 9:24, 1) = 35;
            sample(9:24, 9:24, 2) = 220;
            sample(9:24, 9:24, 3) = 35;

            [exg, filtered] = weedvision.extractVegetationIndex(sample);

            testCase.verifySize(exg, [32 32]);
            testCase.verifySize(filtered, [32 32]);
            testCase.verifyTrue(all(isfinite(exg(:))));
            testCase.verifyTrue(all(isfinite(filtered(:))));
            testCase.verifyGreaterThan(max(exg(:)), min(exg(:)));
        end

        function createsLogicalOtsuMask(testCase)
            sample = [zeros(20, 20), ones(20, 20)];
            [threshold, mask] = weedvision.segmentVegetation(sample);

            testCase.verifyClass(mask, 'logical');
            testCase.verifySize(mask, size(sample));
            testCase.verifyGreaterThanOrEqual(threshold, 0);
            testCase.verifyLessThanOrEqual(threshold, 1);
            testCase.verifyTrue(any(mask(:)));
            testCase.verifyTrue(any(~mask(:)));
        end

        function removesSmallNoiseAndKeepsLargeRegion(testCase)
            sample = false(60, 60);
            sample(20:40, 20:40) = true;
            sample(3:4, 3:4) = true;

            cleaned = weedvision.cleanVegetationMask(sample);

            testCase.verifyTrue(any(cleaned(:)));
            testCase.verifyFalse(cleaned(3, 3));
            testCase.verifyTrue(cleaned(30, 30));
        end

        function measuresSeparateConnectedRegions(testCase)
            sample = false(60, 60);
            sample(5:15, 5:15) = true;
            sample(35:50, 35:50) = true;

            stats = weedvision.measureCandidates(sample);

            testCase.verifyNumElements(stats, 2);
            areas = sort([stats.Area]);
            testCase.verifyEqual(areas, [121 256]);
            testCase.verifyTrue(all(arrayfun(@(s) numel(s.BoundingBox) == 4, stats)));
        end

        function returnsEmptyStatsForEmptyMask(testCase)
            sample = false(20, 20);
            stats = weedvision.measureCandidates(sample);
            testCase.verifyEmpty(stats);
        end
    end
end
