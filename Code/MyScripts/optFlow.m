function [] = optFlow (I1,I2)
    
    %% I1 = normalizeImage(I1)
    %% I2 = normalizeImage(I2)
    
    I1 = double(uint8(normalizeImage(I1).*16))./16;
    I2 =  double(uint8(normalizeImage(I2).*16))./16;
    
    figure();
    imhist(I1);
    
    figure();
    imshow(adapthisteq(I1));
    
  
    figure();
    imshow(adapthisteq(I2));
  
    
    opticalFlow = vision.OpticalFlow();
    opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
    opticalFlow.ReferenceFrameSource = 'Input port';
    
    %  computes the optical flow of the input image I1, using I2 as a 
    % reference frame. This applies when you set the ReferenceFrameSource property to 'Input port'.
    VSQ = step(opticalFlow,I2, I1);
    xPart = real(VSQ);
    yPart = imag(VSQ);
    
    % figure();
    % hist(xPart);
    % title('xhist b4');
    
    
    % figure();
    % hist(yPart);
    % title('yhist b4');
    
   
    absPart = abs(VSQ);
    
    absPart = normalizeImage(absPart);
      
    % figure();
    % imshow(absPart);
    % title('Abs component');
     
    I1 = uint8(adapthisteq(I1).*255);
    
    [labels, numlabels] = SLICdemo(I1, 500, 40);
    
    superpixelBoundaries = drawSuperpixelBoundaries(I1, labels,0);
    
    
    rowsMatrix = zeros(size(I1));
    for i = 1:size(I1,1)
        rowsMatrix(i,:) = i;
    end
    
    columnMatrix = zeros(size(I1));
    for j = 1:size(I1,2)
        columnMatrix(:,j) = j;
    end
    
   
    
    superpixelMeanX = zeros(1, numlabels);
    superpixelMeanY = zeros(1, numlabels);
    superpixelXMotion = zeros(1, numlabels);
    superpixelYMotion = zeros(1, numlabels);

    
    for superPixelIdx = 1:numlabels
        
        neededPixels = (labels ==superPixelIdx);
        
        meanX = mean(rowsMatrix(neededPixels));
        meanY = mean(columnMatrix(neededPixels));
          
        meanXMotion = mean(xPart(neededPixels));
        meanYMotion = mean(yPart(neededPixels));
         
        superpixelMeanX(superPixelIdx) = meanX;
        superpixelMeanY(superPixelIdx) = meanY;
        superpixelXMotion(superPixelIdx) = meanXMotion;
        superpixelYMotion(superPixelIdx) = meanYMotion;
      
      %%  quiver(floor(meanY), floor(meanX), meanXMotion*1000000, meanYMotion*1000000);
    end
    
    figure();
    imshow(superpixelBoundaries);
    title('Boundaries on first Image');
    hold on
   
    
    quiver(floor(superpixelMeanY), floor(superpixelMeanX), superpixelXMotion, superpixelYMotion);
    
    
    % Quiver axis: (0,0) is top left corner
    % first argument is horizontal axis, increases from left to right
    % 2nd argument: vertical axes, increases from top to bottom
    
    % MeanX and Mean Y: (0,0) is top left corner
    % X axis is the row index, vertical axis
    % Y axis is the column index, horizontal axis
    
    figure();
    hist(superpixelXMotion);
    title('SUPERPIXEL X MOTION');
    
    figure();
    hist(superpixelYMotion);
    title('SUPERPIXEL Y MOTION');
    
    
    superPixelMotionMagnitude = sqrt(superpixelXMotion.*superpixelXMotion + superpixelYMotion.*superpixelYMotion);
    
    %% figure();
    %% hist(superPixelMotionMagnitude);
    %% title('SUPERPIXEL MOTION MAG');
    
    [r c] = size(I1);
    indices = r*c
    randIndices = randi([1 indices], 1, floor(indices/200));
    
   
    neededX = rowsMatrix(randIndices);
    neededY = columnMatrix(randIndices);
    
    neededXMotion = xPart(randIndices);
    neededYMotion = yPart(randIndices);
    
    
    figure();
    hist(neededXMotion);
    title('randomly sampled x motion');
    
    figure();
    imshow(superpixelBoundaries);
    title('many vectors');
    hold on;
    quiver(neededY, neededX,neededXMotion,neededYMotion);
    
end
