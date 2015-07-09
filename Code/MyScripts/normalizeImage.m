% Normalizes an image so that values fill the range [0,1]
% imZero: Matrix of the zeroth triplet Image
% imOne: Matrix of teh first triplet Image
% imTwo: Matrix of the second triplet image
% removes the lowest and highest 0.1 percentile of the values in the 3
% images so that images histograms are streched to properly fill the [0,1]
% range

function [resultImageZero, resultImageOne, resultImageTwo] = normalizeImage(imZero, imOne, imTwo)
    imZeroDouble = double(imZero);
    imOneDouble = double(imOne);
    imTwoDouble = double(imTwo);
    
    % remove first and last 0.1 percentiles so as to stretch image
    % histogram to fill full range
    
    concatImage = [imZeroDouble; imOneDouble; imTwoDouble];
    maxValue =   prctile(concatImage(:),99.9);
    minValue =  prctile(concatImage(:),0.1);
    
    %% maxValue = max(max(ImageDouble));
    %% minValue = min(min(ImageDouble));
    
    %% minZero = prctile(imZeroDouble(:), 0.1);
    %% maxZero = prctile(imZeroDouble(:), 99.9);
    ImageZeroShiftedToZero = imZeroDouble - minValue;
    resultImageZero = ImageZeroShiftedToZero/(maxValue - minValue);
    resultImageZero(resultImageZero<0) = 0;
    resultImageZero(resultImageZero>1) = 1;
    
    
    %% minOne = prctile(imOneDouble(:), 0.1);
    %% maxOne = prctile(imOneDouble(:), 99.9);
    ImageOneShiftedToZero = imOneDouble - minValue;
    resultImageOne = ImageOneShiftedToZero/ (maxValue - minValue);
    resultImageOne(resultImageOne<0) = 0;
    resultImageOne(resultImageOne>1) = 1;
    
    
    %% minTwo = prctile(imTwoDouble(:), 0.1);
    %% maxTwo = prctile(imTwoDouble(:), 99.9);
    ImageTwoShiftedToZero = imTwoDouble - minValue;
    resultImageTwo = ImageTwoShiftedToZero/ (maxValue - minValue);
    resultImageTwo(resultImageTwo<0) = 0;
    resultImageTwo(resultImageTwo>1) = 1;
    
    
end