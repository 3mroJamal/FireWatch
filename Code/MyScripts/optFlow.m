function [] = optFlow (I1,I2)
    
    I1 = normalizeImage(I1);
    I2 = normalizeImage(I2);
    
    figure();
    imshow(I1);

    
    figure();
    imshow(I2);
    
    opticalFlow = vision.OpticalFlow();
    opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
    opticalFlow.ReferenceFrameSource = 'Input port';
    VSQ = step(opticalFlow,I1, I2);
    xPart = real(VSQ);
    yPart = imag(VSQ);
    
    figure();
    hist(xPart);
    title('xhist b4');
    
    
    figure();
    hist(yPart);
    title('yhist b4');
    
   
    absPart = abs(VSQ);
    
    absPart = normalizeImage(absPart);
      
    figure();
    imshow(absPart);
    title('Abs component');
     
    I1 = uint8(adapthisteq(I1).*255);
    
    [labels, numlabels] = SLICdemo(I1, 500, 40);
    labels = labels+1;
    
    binaryMask = drawregionboundaries(labels);
    maskedImage = I1;
    maskedImage(binaryMask==1) = 0;
    
    
    
    rowsMatrix = zeros(size(I1));
    for i = 1:size(I1,1)
        rowsMatrix(i,:) = i;
    end
    
    columnMatrix = zeros(size(I1));
    for j = 1:size(I1,2)
        columnMatrix(:,j) = j;
    end
    
    figure();
    imshow(maskedImage);
    
    
    
    for superPixelIdx = 1:numlabels
        hold on
        neededPixels = (labels ==superPixelIdx);
        meanX = mean(rowsMatrix(neededPixels));
        meanY = mean(columnMatrix(neededPixels));
        meanXMotion = mean(xPart(neededPixels));
        meanYMotion = mean(yPart(neededPixels));
        quiver(floor(meanY), floor(meanX), meanYMotion*100000, meanXMotion*100000);
    end
    
end
