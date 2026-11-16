%% Improved Weed Candidate Detection Using MATLAB Image Processing
% This script is an improved, reproducible version of the original project.
% It detects green vegetation candidates using Excess Green (ExG), Otsu
% thresholding and morphological cleanup. It does NOT distinguish crop plants
% from weeds semantically; candidate regions require visual verification.
%
% Requirements: MATLAB + Image Processing Toolbox

clc;
clear;
close all;

%% 1. Select an input image
[fileName, folderName] = uigetfile( ...
    {'*.jpg;*.jpeg;*.png;*.tif;*.tiff', 'Supported images (*.jpg, *.jpeg, *.png, *.tif, *.tiff)'}, ...
    'Select a crop image');

if isequal(fileName, 0)
    disp('No image selected. Processing cancelled.');
    return;
end

inputPath = fullfile(folderName, fileName);
originalImage = imread(inputPath);

if ndims(originalImage) == 2
    originalImage = repmat(originalImage, 1, 1, 3);
elseif size(originalImage, 3) > 3
    originalImage = originalImage(:, :, 1:3);
end

originalImage = im2uint8(originalImage);
imageDouble = im2double(originalImage);

%% 2. Extract colour channels and calculate Excess Green
redChannel   = imageDouble(:, :, 1);
greenChannel = imageDouble(:, :, 2);
blueChannel  = imageDouble(:, :, 3);

% Excess Green Index: emphasizes green vegetation relative to red and blue.
exg = 2 .* greenChannel - redChannel - blueChannel;
exgNormalized = mat2gray(exg);

%% 3. Smooth the vegetation index
filteredExg = medfilt2(exgNormalized, [3 3], 'symmetric');

%% 4. Segment vegetation candidates using Otsu thresholding
thresholdValue = graythresh(filteredExg);
binaryMask = imbinarize(filteredExg, thresholdValue);

%% 5. Clean the binary mask using morphology
se = strel('disk', 2, 0);
cleanMask = imopen(binaryMask, se);
cleanMask = imclose(cleanMask, strel('disk', 3, 0));
cleanMask = imfill(cleanMask, 'holes');

% Remove tiny connected components. Adjust this value for image resolution.
minimumArea = max(10, round(numel(cleanMask) * 0.0001));
cleanMask = bwareaopen(cleanMask, minimumArea);

%% 6. Measure connected candidate regions
components = bwconncomp(cleanMask, 8);
regionStats = regionprops(components, ...
    'Area', 'BoundingBox', 'Centroid', 'Eccentricity');

candidateCount = numel(regionStats);

%% 7. Create a labelled overlay
overlayFigure = figure('Name', 'Weed Candidate Detection', ...
    'Color', 'white', 'NumberTitle', 'off');
imshow(originalImage);
hold on;

for k = 1:candidateCount
    box = regionStats(k).BoundingBox;
    rectangle('Position', box, 'EdgeColor', [1 0.2 0.1], ...
        'LineWidth', 1.5);
    text(box(1), max(1, box(2) - 8), sprintf('Candidate %d', k), ...
        'Color', 'yellow', 'FontSize', 8, 'FontWeight', 'bold', ...
        'BackgroundColor', [0 0 0], 'Margin', 1);
end

title(sprintf('Vegetation Candidates: %d region(s)', candidateCount));
hold off;

%% 8. Display processing stages
figure('Name', 'Image Processing Stages', ...
    'Color', 'white', 'NumberTitle', 'off');

subplot(2, 3, 1);
imshow(originalImage);
title('Original image');

subplot(2, 3, 2);
imshow(exgNormalized, []);
title('Excess Green index');

subplot(2, 3, 3);
imshow(filteredExg, []);
title('Median filtered');

subplot(2, 3, 4);
imshow(binaryMask);
title(sprintf('Otsu segmentation (%.3f)', thresholdValue));

subplot(2, 3, 5);
imshow(cleanMask);
title('Morphological cleanup');

subplot(2, 3, 6);
imshow(label2rgb(bwlabel(cleanMask), 'spring', 'k', 'shuffle'));
title('Connected candidate regions');

%% 9. Save outputs beside the selected image
[~, imageBaseName, ~] = fileparts(fileName);
outputFolder = fullfile(folderName, [imageBaseName '_weed_detection_output']);

if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

imwrite(originalImage, fullfile(outputFolder, '01_original.png'));
imwrite(im2uint8(exgNormalized), fullfile(outputFolder, '02_excess_green.png'));
imwrite(im2uint8(filteredExg), fullfile(outputFolder, '03_filtered.png'));
imwrite(binaryMask, fullfile(outputFolder, '04_initial_segmentation.png'));
imwrite(cleanMask, fullfile(outputFolder, '05_cleaned_mask.png'));

overlayImage = insertShape(originalImage, 'Rectangle', ...
    reshape([regionStats.BoundingBox], 4, []).', ...
    'Color', 'red', 'LineWidth', 3);

imwrite(overlayImage, fullfile(outputFolder, '06_candidate_overlay.png'));

% Save a table of measured regions when candidates are present.
if candidateCount > 0
    candidateID = (1:candidateCount).';
    areaPixels = reshape([regionStats.Area], [], 1);
    eccentricity = reshape([regionStats.Eccentricity], [], 1);
    candidateTable = table(candidateID, areaPixels, eccentricity);
    writetable(candidateTable, fullfile(outputFolder, 'candidate_regions.csv'));
end

% Save the figures for portfolio documentation.
try
    exportgraphics(overlayFigure, ...
        fullfile(outputFolder, '07_detection_result.png'), 'Resolution', 180);
catch
    saveas(overlayFigure, fullfile(outputFolder, '07_detection_result.png'));
end

fprintf('\nProcessing completed.\n');
fprintf('Input image: %s\n', fileName);
fprintf('Vegetation candidate regions: %d\n', candidateCount);
fprintf('Output folder: %s\n', outputFolder);
fprintf(['Note: These are green-vegetation candidates, not verified weed ' ...
    'classifications. Validate against manually labelled ground truth ' ...
    'before reporting accuracy metrics.\n']);
