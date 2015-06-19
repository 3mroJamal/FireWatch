function [] = clusterDirectory(dirPath, tripletsCount, useWhiteMask, clusterNumber, featuresToInclude)

dirInfo = dir(dirPath);

tripletsConsidered = 0;

% each super pixel occupy 1 column in feature Matrix
featureMatrix = zeros(sum(featuresToInclude), 0);

imageDictionary = containers.Map;
labelsDictionary = containers.Map;
numLabelsDictionary = containers.Map;

for i = 3:size(dirInfo)
    
    [pathstr,nameNoExt,ext] = fileparts(dirInfo(i).name);
    if ~(isequal('.tif', ext) || isequal('.png', ext))
        continue;
    end
    
    
    if (tripletsConsidered == tripletsCount)
        break;
    end
    
    lastCharacter = nameNoExt(size(nameNoExt,2));
    if(lastCharacter == '0')
        
        tripletsConsidered = tripletsConsidered+1;
        imZeroName = strcat(nameNoExt, ext);
        imOneName = nameNoExt;
        imOneName(size(imOneName,2)) = '1';
        imOneName = strcat(imOneName, ext);
        
        imTwoName = nameNoExt;
        imTwoName(size(imTwoName,2)) = '2';
        imTwoName = strcat(imTwoName, ext);
        
        % concat directory so that image can be read regardless what
        % current matlab directory is
        imZero = imread(fullfile(dirPath,imZeroName));
        imOne = imread(fullfile(dirPath,imOneName));
        imTwo = imread(fullfile(dirPath,imTwoName));
       
        
        imZeroNormalized = normalizeImage(imZero);
        
        imZeroGrayScale = uint8(imZeroNormalized.*255);
        
        
        SuperPixelNumber = 500;
        CompactnessFactor = 40;
        [Labels, numLabels] = SLICdemo(imZeroGrayScale, SuperPixelNumber, CompactnessFactor);
        %%[Labels, numLabels] = slicBlocks(imZeroGrayScale, 24);
        
       
        %% figure();
        %% imshow(drawSuperpixelBoundaries(imZeroGrayScale, Labels, numLabels));
        
        colorFeatureMatrix = extractFeatures(imZero, Labels, numLabels);
        
        imOneNormalized = normalizeImage(imOne);
        
        %%% demoflow(imZeroNormalized,imOneNormalized);
        
        motionFeatureMatrix = extractMotionFeatures(imZeroNormalized, imOneNormalized, Labels,numLabels);
        
        diffFeatureMatrix = extractDiffImageFeatures(imZero, imOne, imTwo, Labels, numLabels);
        
        relativeIntensityFeatureMatrix = extractRelativeIntensityFeatures(imZeroNormalized, colorFeatureMatrix(1,:), ceil(colorFeatureMatrix(3,:)), ceil(colorFeatureMatrix(4,:)), numLabels, 2);
        
        featureMatrixOfCurrentTriplet = [colorFeatureMatrix; motionFeatureMatrix; diffFeatureMatrix; relativeIntensityFeatureMatrix];
        
       
        %% An idea to normalize features first Per Image 
        %% featureMatrixOfCurrentTriplet = normalizeFeatures(featureMatrixOfCurrentTriplet);
        
        %% visualizeFeatureMagnitudes(imZeroNormalized, featureMatrixOfCurrentTriplet, getFeatureNames(), Labels, colorFeatureMatrix(3,:), colorFeatureMatrix(4,:));
        
        featureMatrix = [featureMatrix, featureMatrixOfCurrentTriplet];
        
        imageDictionary(num2str(tripletsConsidered)) = imZeroNormalized;
        labelsDictionary(num2str(tripletsConsidered)) = Labels;
        numLabelsDictionary(num2str(tripletsConsidered)) = numLabels;
        
    end
    
end

originalFeatureMatrix = featureMatrix;
featureMatrix = normalizeFeatures(featureMatrix);

%% cell array of feature names
featureNames = getFeatureNames();
featureNamesCut = featureNames(featuresToInclude>0);


for featureIdx = 1: size(featureNames,2)
    figure();
    hist(originalFeatureMatrix(featureIdx,:));
    title(featureNames(featureIdx));
end

originalFeatureMatrixCut = originalFeatureMatrix(featuresToInclude>0, :);
featureMatrixCut = featureMatrix(featuresToInclude>0, :);


% kmeans expects a matrix where rows correspond to points
% SuperPixelClusterIndices = kmeans(featureMatrix', clusterNumber);


% EM algorithm expects columns as points
SuperPixelClusterIndices = emgm(featureMatrixCut, clusterNumber);

% splits image superpixels belonging to different clusters to different
% figures
%%% visualizeClustersInSeparateImages(imageDictionary, labelsDictionary, numLabelsDictionary, SuperPixelClusterIndices, clusterNumber);


visualizeClustersUsingAlphaBlending(imageDictionary, labelsDictionary, numLabelsDictionary, SuperPixelClusterIndices, 0.8);



% Draw Histograms of features per cluster. Original (non-normalized)
% feature values are used
drawClusterHistograms(originalFeatureMatrixCut, featureNamesCut,  clusterNumber, SuperPixelClusterIndices);

% draw pairwise scatter plots of feature pairs
% drawScatterPlots(originalFeatureMatrix, featureNames);

% function expects that every row in featurematrix is a superpixel
pcaOnFeatureMatrix(featureMatrixCut', featureNamesCut, clusterNumber, SuperPixelClusterIndices);




end