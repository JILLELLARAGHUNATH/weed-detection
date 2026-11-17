%% Modular Weed Candidate Detection
% Entry point for the modular implementation in the +weedvision package.
% The original main.m and the standalone main_improved.m are retained.
%
% Requirements: MATLAB + Image Processing Toolbox

clc;
clear;
close all;

%% 1. Select input image
[fileName, folderName] = uigetfile( ...
    {'*.jpg;*.jpeg;*.png;*.tif;*.tiff', ...
    'Supported images (*.jpg, *.jpeg, *.png, *.tif, *.tiff)'}, ...
    'Select a crop image');

if isequal(fileName, 0)
    disp('No image selected. Processing cancelled.');
    return;
end

inputPath = fullfile(folderName, fileName);
originalImage = weedvision.readImage(inputPath);

%% 2. Run the image-processing pipeline
[exgNormalized, filteredExg] = weedvision.extractVegetationIndex(originalImage);
[thresholdValue, initialMask] = weedvision.segmentVegetation(filteredExg);
cleanMask = weedvision.cleanVegetationMask(initialMask);
regionStats = weedvision.measureCandidates(cleanMask);

%% 3. Display and export results
[overlayFigure, stagesFigure] = weedvision.displayResults( ...
    originalImage, exgNormalized, filteredExg, initialMask, ...
    cleanMask, regionStats, thresholdValue);

outputFolder = weedvision.saveResults( ...
    inputPath, originalImage, exgNormalized, filteredExg, ...
    initialMask, cleanMask, regionStats, overlayFigure);

fprintf('\nProcessing completed.\n');
fprintf('Input image: %s\n', fileName);
fprintf('Vegetation candidate regions: %d\n', numel(regionStats));
fprintf('Output folder: %s\n', outputFolder);
fprintf(['Note: Regions are green-vegetation candidates, not verified weed ' ...
    'classifications. Validate against independent ground-truth labels ' ...
    'before reporting performance metrics.\n']);

% Keep figure variables in the workspace until the script finishes.
disp('Both result figures are open for inspection.');
