function [overlayFigure, stagesFigure] = displayResults( ...
    originalImage, exgNormalized, filteredExg, initialMask, ...
    cleanMask, regionStats, thresholdValue)
%DISPLAYRESULTS Display candidate boxes and intermediate processing stages.

    candidateCount = numel(regionStats);
    overlayFigure = figure('Name', 'Vegetation Candidate Detection', ...
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

    stagesFigure = figure('Name', 'Image Processing Stages', ...
        'Color', 'white', 'NumberTitle', 'off');

    subplot(2, 3, 1); imshow(originalImage); title('Original image');
    subplot(2, 3, 2); imshow(exgNormalized, []); title('Excess Green index');
    subplot(2, 3, 3); imshow(filteredExg, []); title('Median filtered');
    subplot(2, 3, 4);
    imshow(initialMask);
    title(sprintf('Otsu segmentation (%.3f)', thresholdValue));
    subplot(2, 3, 5); imshow(cleanMask); title('Morphological cleanup');
    subplot(2, 3, 6);
    imshow(label2rgb(bwlabel(cleanMask), 'spring', 'k', 'shuffle'));
    title('Connected candidate regions');
end
