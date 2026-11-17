function regionStats = measureCandidates(cleanMask)
%MEASURECANDIDATES Measure connected vegetation candidate regions.

    validateattributes(cleanMask, {'logical', 'numeric'}, ...
        {'2d', 'nonempty'});

    components = bwconncomp(logical(cleanMask), 8);
    regionStats = regionprops(components, ...
        'Area', 'BoundingBox', 'Centroid', 'Eccentricity');
end
