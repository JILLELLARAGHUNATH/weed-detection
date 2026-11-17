function image = readImage(inputPath)
%READIMAGE Read and normalize a grayscale or RGB field image.
%   IMAGE = weedvision.readImage(INPUTPATH) returns an uint8 RGB image.

    if ~isfile(inputPath)
        error('weedvision:FileNotFound', 'Input image not found: %s', inputPath);
    end

    image = imread(inputPath);

    % Convert grayscale images to three channels.
    if ndims(image) == 2
        image = repmat(image, 1, 1, 3);
    elseif size(image, 3) > 3
        % Discard alpha or additional channels for RGB processing.
        image = image(:, :, 1:3);
    elseif size(image, 3) ~= 3
        error('weedvision:UnsupportedImage', ...
            'Expected a grayscale or RGB image.');
    end

    image = im2uint8(image);
end
