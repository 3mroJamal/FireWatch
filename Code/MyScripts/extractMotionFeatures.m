% feature order
% 1- Velocity in X direction
% 2- STD of X velocity
% 3- Velocity in Y direction
% 4- STD of Y velocity

function [motionFeatureMatrix] = extractMotionFeatures(NormalizedImageOne, NormalizedImageTwo, Labels, numLabels)
    motionFeatureMatrix = zeros(4, numLabels);
    [rows, cols] = size(NormalizedImageOne);
    
    opticalFlow = vision.OpticalFlow();
    opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
    opticalFlow.ReferenceFrameSource = 'Input port';
    
    %  computes the optical flow of the input image I1, using I2 as a 
    % reference frame. This applies when you set the ReferenceFrameSource property to 'Input port'.
    VSQ = step(opticalFlow,NormalizedImageTwo, NormalizedImageOne);
    xPart = real(VSQ);
    yPart = imag(VSQ);
    
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
        
    end
    
    
end