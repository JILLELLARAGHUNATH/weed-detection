function [exgNormalized, filteredExg] = extractVegetationIndex(image)
%EXTRACTVEGETATIONINDEX Calculate and smooth the Excess Green index.
%   EXG = 2G - R - B. The output is normalized to [0,1] and median-filtered.

    validateattributes(image, {'uint8', 'uint16', 'single', 'double'}, ...
        {'nonempty', '3d'});
    if size(image, 3) ~= 3
        error('weedvision:InvalidChannels', 'Input must have three RGB channels.');
    end

    imageDouble = im2double(image);
    redChannel = imageDouble(:, :, 1);
    greenChannel = imageDouble(:, :, 2);
    blueChannel = imageDouble(:, :, 3);

    exg = 2 .* greenChannel - redChannel - blueChannel;
    exgNormalized = mat2gray(exg);
    filteredExg = medfilt2(exgNormalized, [3 3], 'symmetric');
end
