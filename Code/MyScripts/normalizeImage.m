function resultImage = normalizeImage(GrayScaleImage)
    % Normalizes an image so that values fill the range [0,255]
    % GrayScaleImage: Matrix of the GrayScale Image with depth = 1
    ImageDouble = double(GrayScaleImage);
    maxValue = max(max(ImageDouble));
    minValue = min(min(ImageDouble));
    ImageShiftedToZero = ImageDouble - minValue;
    resultImage = ImageShiftedToZero/(maxValue - minValue);
end