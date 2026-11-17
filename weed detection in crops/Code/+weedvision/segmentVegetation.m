function [thresholdValue, binaryMask] = segmentVegetation(filteredExg)
%SEGMENTVEGETATION Segment candidate vegetation using Otsu thresholding.

    validateattributes(filteredExg, {'numeric', 'logical'}, ...
        {'2d', 'nonempty', 'finite'});

    thresholdValue = graythresh(filteredExg);
    binaryMask = imbinarize(filteredExg, thresholdValue);
end
