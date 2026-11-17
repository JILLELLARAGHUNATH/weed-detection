%% Weed Detection in Crops - Reviewed MATLAB Workflow
% A safer, configurable image-processing workflow for highlighting
% vegetation candidates. This is not semantic weed classification.
%
% Requirements: MATLAB + Image Processing Toolbox.

clc;
close all;

%% Configuration
minimumAreaPixels = 10;       % Remove components smaller than this area
medianFilterSize = [3 3];     % Median filter neighbourhood
morphologyRadius = 2;         % Disk radius for morphological opening
showIntermediateStages = true;
saveResults = true;

%% Select and validate input image
[fileName, folderName] = uigetfile( ...
    {'*.jpg;*.jpeg;*.png;*.tif;*.tiff;*.bmp', 'Supported image files'}, ...
    'Select a crop-field image');

if isequal(fileName, 0)
    fprintf('Image selection cancelled.\n');
    return;
end

inputPath = fullfile(folderName, fileName);
rgbImage = imread(inputPath);

if ndims(rgbImage) == 2
    rgbImage = repmat(rgbImage, 1, 1, 3);
elseif size(rgbImage, 3) == 4
    rgbImage = rgbImage(:, :, 1:3);
elseif size(rgbImage, 3) ~= 3
    error('Unsupported image format: expected a grayscale or RGB image.');
end

rgbImage = im2uint8(rgbImage);
imageDouble = im2double(rgbImage);

if max(imageDouble(:)) == min(imageDouble(:))
    error('The selected image has no intensity variation. Choose another image.');
end

%% Vegetation emphasis: Excess Green index
red = imageDouble(:, :, 1);
green = imageDouble(:, :, 2);
blue = imageDouble(:, :, 3);

exg = 2 .* green - red - blue;
exgNormalized = mat2gray(exg);

%% Denoising and threshold segmentation
filteredExg = medfilt2(exgNormalized, medianFilterSize, 'symmetric');
thresholdValue = graythresh(filteredExg);
initialMask = imbinarize(filteredExg, thresholdValue);

%% Morphological cleanup
structuringElement = strel('disk', morphologyRadius, 0);
cleanMask = imopen(initialMask, structuringElement);
cleanMask = imclose(cleanMask, structuringElement);
cleanMask = imfill(cleanMask, 'holes');
cleanMask = bwareaopen(cleanMask, minimumAreaPixels);

%% Connected-component analysis
components = bwconncomp(cleanMask, 8);
regionStats = regionprops(components, ...
    'Area', 'BoundingBox', 'Centroid', 'Eccentricity');

candidateCount = numel(regionStats);

%% Visualise candidate regions
resultFigure = figure('Name', 'Weed Detection - Candidate Regions', ...
    'Color', 'white', 'NumberTitle', 'off');
imshow(rgbImage);
hold on;

for idx = 1:candidateCount
    rectangle('Position', regionStats(idx).BoundingBox, ...
        'EdgeColor', [1 0.25 0.1], 'LineWidth', 1.7);
    center = regionStats(idx).Centroid;
    plot(center(1), center(2), 'y+', 'MarkerSize', 6, 'LineWidth', 1);
end

title(sprintf('Vegetation candidates detected: %d', candidateCount));
hold off;

%% Show processing stages
if showIntermediateStages
    stagesFigure = figure('Name', 'Processing Pipeline', ...
        'Color', 'white', 'NumberTitle', 'off');

    subplot(2, 3, 1); imshow(rgbImage); title('Original image');
    subplot(2, 3, 2); imshow(exgNormalized, []); title('Excess Green');
    subplot(2, 3, 3); imshow(filteredExg, []); title('Median filtering');
    subplot(2, 3, 4); imshow(initialMask); 
    title(sprintf('Otsu threshold: %.3f', thresholdValue));
    subplot(2, 3, 5); imshow(cleanMask); title('Cleaned binary mask');

    if candidateCount > 0
        labelledImage = label2rgb(bwlabel(cleanMask), 'spring', 'k', 'shuffle');
        subplot(2, 3, 6); imshow(labelledImage);
    else
        subplot(2, 3, 6); imshow(cleanMask);
    end
    title('Connected regions');
end

%% Export reproducible outputs
if saveResults
    [~, baseName, ~] = fileparts(fileName);
    outputFolder = fullfile(folderName, [baseName '_weed_detection_results']);

    if ~isfolder(outputFolder)
        mkdir(outputFolder);
    end

    imwrite(rgbImage, fullfile(outputFolder, '01_original.png'));
    imwrite(im2uint8(exgNormalized), fullfile(outputFolder, '02_excess_green.png'));
    imwrite(im2uint8(filteredExg), fullfile(outputFolder, '03_filtered.png'));
    imwrite(initialMask, fullfile(outputFolder, '04_initial_mask.png'));
    imwrite(cleanMask, fullfile(outputFolder, '05_cleaned_mask.png'));

    if candidateCount > 0
        candidateID = (1:candidateCount).';
        areaPixels = reshape([regionStats.Area], [], 1);
        eccentricity = reshape([regionStats.Eccentricity], [], 1);
        centroidX = arrayfun(@(s) s.Centroid(1), regionStats).';
        centroidY = arrayfun(@(s) s.Centroid(2), regionStats).';

        candidateTable = table(candidateID, areaPixels, eccentricity, ...
            centroidX, centroidY);
    else
        candidateTable = table(zeros(0,1), zeros(0,1), zeros(0,1), ...
            zeros(0,1), zeros(0,1), ...
            'VariableNames', {'CandidateID','AreaPixels','Eccentricity', ...
            'CentroidX','CentroidY'});
    end

    writetable(candidateTable, fullfile(outputFolder, 'candidate_regions.csv'));

    try
        exportgraphics(resultFigure, ...
            fullfile(outputFolder, '06_detection_overlay.png'), ...
            'Resolution', 180);
    catch
        saveas(resultFigure, fullfile(outputFolder, '06_detection_overlay.png'));
    end

    if showIntermediateStages
        try
            exportgraphics(stagesFigure, ...
                fullfile(outputFolder, '07_processing_stages.png'), ...
                'Resolution', 180);
        catch
            saveas(stagesFigure, fullfile(outputFolder, '07_processing_stages.png'));
        end
    end

    fprintf('Results saved to: %s\n', outputFolder);
end

%% Summary
fprintf('\nProcessing completed.\n');
fprintf('Input image: %s\n', fileName);
fprintf('Otsu threshold: %.4f\n', thresholdValue);
fprintf('Candidate regions: %d\n', candidateCount);
fprintf(['Interpretation: detected regions are vegetation candidates, not ' ...
    'verified weeds. Use independently annotated ground truth for accuracy evaluation.\n']);
