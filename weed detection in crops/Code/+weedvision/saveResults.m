function outputFolder = saveResults(inputPath, originalImage, ...
    exgNormalized, filteredExg, initialMask, cleanMask, ...
    regionStats, overlayFigure)
%SAVERESULTS Export intermediate images, candidate measurements and overlay.

    [folderName, imageBaseName] = fileparts(inputPath);
    outputFolder = fullfile(folderName, [imageBaseName '_weed_detection_output']);

    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    imwrite(originalImage, fullfile(outputFolder, '01_original.png'));
    imwrite(im2uint8(exgNormalized), fullfile(outputFolder, '02_excess_green.png'));
    imwrite(im2uint8(filteredExg), fullfile(outputFolder, '03_filtered.png'));
    imwrite(initialMask, fullfile(outputFolder, '04_initial_segmentation.png'));
    imwrite(cleanMask, fullfile(outputFolder, '05_cleaned_mask.png'));

    if ~isempty(regionStats)
        candidateID = (1:numel(regionStats)).';
        areaPixels = reshape([regionStats.Area], [], 1);
        eccentricity = reshape([regionStats.Eccentricity], [], 1);
        candidateTable = table(candidateID, areaPixels, eccentricity);
        writetable(candidateTable, fullfile(outputFolder, 'candidate_regions.csv'));
    else
        % Write a header-only CSV so that an empty result is explicit.
        candidateTable = table(zeros(0, 1), zeros(0, 1), zeros(0, 1), ...
            'VariableNames', {'candidateID', 'areaPixels', 'eccentricity'});
        writetable(candidateTable, fullfile(outputFolder, 'candidate_regions.csv'));
    end

    try
        exportgraphics(overlayFigure, ...
            fullfile(outputFolder, '06_detection_result.png'), 'Resolution', 180);
    catch
        saveas(overlayFigure, fullfile(outputFolder, '06_detection_result.png'));
    end
end
