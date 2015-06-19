% Normalizes an image so that values fill the range [0,255]
% GrayScaleImage: Matrix of the Input Image

function resultImage = normalizeImage(GrayScaleImage)
    ImageDouble = double(GrayScaleImage);
    
    % remove first and last 0.1 percentiles so as to stretch image
    % histogram to fill full range
    maxValue =   prctile(ImageDouble(:),99.9);
    minValue =  prctile(ImageDouble(:),0.1);
    
    %% maxValue = max(max(ImageDouble));
    %% minValue = min(min(ImageDouble));
    ImageShiftedToZero = ImageDouble - minValue;
    resultImage = ImageShiftedToZero/(maxValue - minValue);
    resultImage(resultImage<0) = 0;
    resultImage(resultImage>1) = 1;
    
end