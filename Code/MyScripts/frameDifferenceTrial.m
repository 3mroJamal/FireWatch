% A trail function that computes diff image of first two images
% tries adaptively equalizing the diff image -> bad as this introduce noise
%% Note: equalizing the diff Image is a bad Idea, as it increases noise significantly
%% Histogram of diff image has a steep laplacian distribution, I tried 
% removing the highest 1% and scaling the histogram of the diff image to
% fill the [0,255] range
function [] = frameDifferenceTrial(I1,I2,I3)
    
    normalizedI1 = uint8(normalizeImage(I1).*255);
    equalizedI1 = adapthisteq(normalizedI1);
    figure();
    imshow(equalizedI1);
    title('Equalized Image One');
    
    normalizedI2 = uint8(normalizeImage(I2).*255);
    equalizedI2 = adapthisteq(normalizedI2);
    figure();
    imshow(equalizedI2);
    title('Equalized Image Two');
    
    
    diffImage = abs(int32(I1) - int32(I2));
    diffImage = uint8(normalizeImage(diffImage).*255);
    
    figure();
    imshow(diffImage);
    title('diff Image');
    
   
    figure();
    imhist(diffImage);
    title('diff Image hist');
    
    
    ninetyninthPercentile = prctile(double(diffImage(:)),99)
    
    scaledDiffImage = uint8( double(diffImage).*(255/ninetyninthPercentile));
    figure();
    imshow(scaledDiffImage);
    title('scaled Diff Image');
    figure();
    imhist(scaledDiffImage);
    title('scaled diff Image hist');
    
    
end