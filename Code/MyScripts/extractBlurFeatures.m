function [] = extractBlurFeatures(imZero)
    imZeroNormalized = normalizeImage(imZero);
    filter = fspecial('gaussian',[5 5],2);
    %# Filter it
    IBlurred = imfilter(imZeroNormalized,filter,'same');
    %# Display
    figure();
    imshow(imZeroNormalized);
    title('Original Image');
    
    figure();
    imshow(IBlurred);
    title('Blurred Image');
   
    
    
    diffImage = abs(IBlurred - imZeroNormalized);
    
    figure();
    imhist(imZeroNormalized);
    title('Histogram of Original Image');
    
    figure();
    imhist(IBlurred);
    title('hist of blurred image');
    
    figure();
    imhist(diffImage);
    title('hist of diff image');
    
    
    figure();
    imshow(diffImage);
    title('Original Diff Image');
    
    normalizedDiffImage = normalizeImage(diffImage);
    figure();
    imshow(normalizedDiffImage);
    title('normalizedDiffImage');
    
    
    figure();
    imhist(normalizedDiffImage);
    title('Hist of normalized diff Image');
    
    figure();
    imshow(normalizedDiffImage, [0 0.3]);
    title('New Normalized Image');
    
end