% Returns a motion feature matrix with the following features
% 1- Velocity in X direction
% 2- STD of X velocity
% 3- Velocity in Y direction
% 4- STD of Y velocity

% NormalizedImageOne: first Image as double and in range [0,1]
% NormalizedImageTwo: second Image as double and in range [0,1]
% Labels of superpixels (1-based) where every pixel is labelled to which
% superpixel does it belong
% numLabels: number of superpixels
% startingImage: if Zero, calculate optical flow between images zero and
% one, If 1, calculate it between 1 and 2

function [motionFeatureMatrix] = extractMotionFeatures(NormalizedImageOne, NormalizedImageTwo, Labels, numLabels, dirPath, imageName, startingImage)
    motionFeatureMatrix = zeros(4, numLabels);
    [rows, cols] = size(NormalizedImageOne);
    
    
     %%%% opticalFlow = vision.OpticalFlow();
     %%%% opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
     %%%% opticalFlow.ReferenceFrameSource = 'Input port';
    
    %  computes the optical flow of the input image I1, using I2 as a 
    % reference frame. This applies when you set the ReferenceFrameSource property to 'Input port'.
     %%%% VSQ = step(opticalFlow,NormalizedImageTwo, NormalizedImageOne);
     %%%% xPart = real(VSQ);
     %%%% yPart = imag(VSQ);
    
    %% X, horizontal motion from left to right
    %% Y, vertical motion from top to bottom
    %%%%%%%[xPart, yPart] = demoflow(NormalizedImageOne, NormalizedImageTwo);
    
    if(startingImage ==0)
        opticalFlowDirectory = 'opticalFlowZeroOne';
    elseif(startingImage ==1)
        opticalFlowDirectory = 'opticalFlowOneTwo';
    else
        opticalFlowDirectory = 'opticalFlowZeroTwo';
    end
    
    xPartFilePath = fullfile(dirPath, opticalFlowDirectory, strcat(imageName, '_vx'));
    xPart = dlmread(xPartFilePath);
    
    yPartFilePath = fullfile(dirPath, opticalFlowDirectory, strcat(imageName, '_vy'));
    yPart = dlmread(yPartFilePath);
    
    visualizeOpticalFlowArrows(NormalizedImageOne, xPart, yPart);
    fprintf('%s\n', imageName);
    
    %% [magnitude, angle] = computeMagnitudeAngle(xPart, yPart);
    
    for superpixelIdx = 1:numLabels
        neededPixels = (Labels==superpixelIdx);
        motionInXDirection = xPart(neededPixels);
        meanMotionInXDirection = mean(motionInXDirection);
        stdMotionInXDirection = std(double(motionInXDirection));
        
        motionFeatureMatrix(1, superpixelIdx) = meanMotionInXDirection;
        motionFeatureMatrix(2, superpixelIdx) = stdMotionInXDirection;
        
        
        motionInYDirection = yPart(neededPixels);
        meanMotionInYDirection = mean(motionInYDirection);
        stdMotionInYDirection = std(double(motionInYDirection));
        
        motionFeatureMatrix(3, superpixelIdx) = meanMotionInYDirection;
        motionFeatureMatrix(4, superpixelIdx) = stdMotionInYDirection;
        
        %% motionMagnitude = magnitude(neededPixels);
        %% meanMotionMagnitude = mean(motionMagnitude);
        %% stdMotionMagnitude = std(double(motionMagnitude));
        
        %% motionFeatureMatrix(1, superpixelIdx) = meanMotionMagnitude;
        %% motionFeatureMatrix(2, superpixelIdx) = stdMotionMagnitude;

        
        %% motionAngle = angle(neededPixels);
        %% meanMotionAngle = mean(motionAngle);
        %% stdMotionAngle = std(motionAngle);

        %% motionFeatureMatrix(3, superpixelIdx) = meanMotionAngle;
        %% motionFeatureMatrix(4, superpixelIdx) = stdMotionAngle;
        
    end
    

end