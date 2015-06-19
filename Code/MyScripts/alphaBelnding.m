% image: double image in range [0 1]
% alpha: belnding factor (blendedImage = alpha*original + (1-alpha)*labelImage)
% labelImage: image indincation to which cluster each pixel belongs

function [blendedImage] = alphaBelnding(image, alpha, labelImage)
    colormap = [0 0 1; 0 1 0; 1 0 0; 0 1 1; 1 0 1; 1 1 0; 1 0.5 0; 0.6 0.3 0.3; 0.2 0.7 0.5; 1 1 1];
    
    %% image = normalizeImage(image);
    
    [rows, cols] = size(image);
    imageRGB = zeros(rows, cols, 3);
    imageRGB(:,:,1) = image;
    imageRGB(:,:,2) = image;
    imageRGB(:,:,3) = image;
    
    
    
    labelImageRGB = zeros(rows, cols, 3);
 
    labelImageRed = zeros(rows, cols);
    labelImageGreen = zeros(rows, cols);
    labelImageBlue = zeros(rows, cols);
    
    minLabel = min(min(labelImage));
    maxLabel = max(max(labelImage));
    
    for labelIdx = minLabel:maxLabel
        neededColor = colormap(labelIdx, :);

        redComp = neededColor(1);
        greenComp = neededColor(2);
        blueComp = neededColor(3);
        
        neededPositions = labelImage == labelIdx;
        labelImageRed(neededPositions) = redComp;
        labelImageGreen(neededPositions) = greenComp;
        labelImageBlue(neededPositions) = blueComp;
    end
    labelImageRGB(:,:,1) = labelImageRed;
    labelImageRGB(:,:,2) = labelImageGreen;
    labelImageRGB(:,:,3) = labelImageBlue;
  
    
    
    %% figure();
    %% imshow(labelImageRGB);
    %% title('labelImageRGB');
   
    
    
    blendedImage = alpha*imageRGB + (1-alpha)*labelImageRGB;
    %% figure();
    %% imshow(blendedImage);
    %% title('Blended Image');
    
    
    
    
end