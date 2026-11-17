function cleanMask = cleanVegetationMask(binaryMask)
%CLEANVEGETATIONMASK Apply morphology and remove small components.

    validateattributes(binaryMask, {'logical', 'numeric'}, ...
        {'2d', 'nonempty'});

    cleanMask = logical(binaryMask);
    cleanMask = imopen(cleanMask, strel('disk', 2, 0));
    cleanMask = imclose(cleanMask, strel('disk', 3, 0));
    cleanMask = imfill(cleanMask, 'holes');

    minimumArea = max(10, round(numel(cleanMask) * 0.0001));
    cleanMask = bwareaopen(cleanMask, minimumArea);
end
