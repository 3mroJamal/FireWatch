% perfomrs SLIC algorithm on color image
% used to verify that SLIC produces straight edges on homogenous images (not so many edges)
% Command: 
% I = imread('D:\trailImagesForSLIC\tomAndJerryHD.jpg');
% slicOnColorImage(I, 500, 40, 0);


function [] = slicOnColorImage(image, superpixelNumber, compactnessFactor, useWhiteMask)
    [a,b,c] = size(image);
   
    figure();
    imshow(image);
    
    if(c==3)
        image = rgb2gray(image);
    end
    
    imageNormalized = uint8(normalizeImage(image).*255);
    imageEqualized = adapthisteq(imageNormalized);
   
    
    [labels, numlabels] = SLICdemo(imageEqualized, superpixelNumber, compactnessFactor);
    
    
    figure();
    imshow(drawSuperpixelBoundaries(imageEqualized, labels, useWhiteMask));
    
end