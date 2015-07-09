% This is the main script
% It applies K-means to superpixels in a directory of images using the
% feature vectors extracted from the superpixels
% dirPath: Path to the directory of the triplets
% tripletsCount: number of triplets to cluster in the given directory, -1
% means cluster all the directory
% useWhiteMask: boolean that specifies whether to use a white mask when
% drawing superpixel boundaries or not
% clusterNumber: number of clusters
% featuresToInclude: boolean vector indicating which features to include in
% the clustering

% example command:
% clusterDirectory('D:\FireWatch\SampleImagesRaw\confirmedGermany\confirmedGermanyTrainAll\', -1, 0, 4, [1 1 1 1 1 1 1 1 1 1 0]);

function [] = clusterDirectory(dirPath, tripletsCount, useWhiteMask, clusterNumber, featuresToInclude, clusterNumberSecondRound, featureToIncludeSecondRound)

dirInfo = dir(dirPath);

tripletsConsidered = 0;

% each super pixel occupy 1 column in feature Matrix
featureMatrix = zeros(sum(featuresToInclude), 0);

imageDictionary = containers.Map;
labelsDictionary = containers.Map;
numLabelsDictionary = containers.Map;
imageNamesDictionary = containers.Map;

imageNumber = 1;

%% If feature matrix exists, just load it, else compute it and save it to disk
pathToFeatureMatrix = fullfile(dirPath,'featureMatrix.mat');
featureMatrixExists = 0;

if(exist(pathToFeatureMatrix) == 2)
    load(pathToFeatureMatrix);
    featureMatrixExists = 1;
end

for i = 3:size(dirInfo)
    [pathstr,nameNoExt,ext] = fileparts(dirInfo(i).name);
    
    % Images considered are either tif or png
    if ~(isequal('.tif', ext) || isequal('.png', ext))
        continue;
    end
    
    if (tripletsConsidered == tripletsCount)
        break;
    end
    
    fprintf('Image: %i\n', imageNumber);
    
    % consider only triplet by triplet
    orderInTriplet = nameNoExt(size(nameNoExt,2));
    
    if(orderInTriplet~='0')
        continue;
    end
    
    
    imZeroNameNoExt = nameNoExt;
    imZeroNameNoExt(size(imZeroNameNoExt,2)) = '0';
    imZeroName = strcat(imZeroNameNoExt, ext);
    
    imOneNameNoExt = nameNoExt;
    imOneNameNoExt(size(imOneNameNoExt,2)) = '1';
    imOneName = strcat(imOneNameNoExt, ext);
    
    imTwoNameNoExt = nameNoExt;
    imTwoNameNoExt(size(imTwoNameNoExt,2)) = '2';
    imTwoName = strcat(imTwoNameNoExt, ext);
    
    % Concat directory so that image can be read regardless what
    % current matlab directory is
    imZero = imread(fullfile(dirPath,imZeroName));
    imOne = imread(fullfile(dirPath,imOneName));
    imTwo = imread(fullfile(dirPath,imTwoName));
    
    [imZeroNormalized, imOneNormalized, imTwoNormalized] = normalizeImage(imZero, imOne, imTwo);
    
    pathToLabelsFileZero = fullfile(dirPath, 'slicZero', strcat(imZeroNameNoExt,'.tif'));
    %% LabelsZero = dlmread(pathToLabelsFileZero);
    LabelsZero = imread(pathToLabelsFileZero);
    numLabelsZero = max(max(LabelsZero));
    
    if(~featureMatrixExists)
        colorFeatureMatrixZero = extractFeatures(imZeroNormalized, LabelsZero, numLabelsZero);
        
        motionFeatureMatrixZero = extractMotionFeatures(imZeroNormalized, imOneNormalized, LabelsZero,numLabelsZero, dirPath, imZeroNameNoExt,0);
        
        diffFeatureMatrixZero = extractDiffImageFeatures(imZeroNormalized, imOneNormalized, LabelsZero, numLabelsZero);
        
        relativeIntensityFeatureMatrixZero = extractRelativeIntensityFeatures(imZeroNormalized, colorFeatureMatrixZero(1,:), ceil(colorFeatureMatrixZero(3,:)), ceil(colorFeatureMatrixZero(4,:)), numLabelsZero, 1);
        
        featureMatrixOfCurrentTripletZero = [colorFeatureMatrixZero; motionFeatureMatrixZero; diffFeatureMatrixZero; relativeIntensityFeatureMatrixZero];
        
        
        %% An idea to normalize features first Per Image
        featureMatrixOfCurrentTripletZero = normalizeFeatures(featureMatrixOfCurrentTripletZero);
        
        featureMatrix = [featureMatrix, featureMatrixOfCurrentTripletZero];
    end
    
    imageDictionary(num2str(imageNumber)) = imZeroNormalized;
    labelsDictionary(num2str(imageNumber)) = LabelsZero;
    numLabelsDictionary(num2str(imageNumber)) = numLabelsZero;
    imageNamesDictionary(num2str(imageNumber)) = strcat(nameNoExt, ext);
    imageNumber = imageNumber+1;
    
    
    
    pathToLabelsFileOne = fullfile(dirPath, 'slicOne', strcat(imOneNameNoExt,'.tif'));
    %%% pathToLabelsFileOne = fullfile(dirPath, 'slicZero', strcat(imZeroNameNoExt,'.tif'));
    %% LabelsOne = dlmread(pathToLabelsFileOne);
    LabelsOne = imread(pathToLabelsFileOne);
    numLabelsOne = max(max(LabelsOne));
    
    if(~featureMatrixExists)
        
        colorFeatureMatrixOne = extractFeatures(imOneNormalized, LabelsOne, numLabelsOne);
        
        motionFeatureMatrixOne = extractMotionFeatures(imZeroNormalized, imOneNormalized, LabelsOne,numLabelsOne, dirPath, imOneNameNoExt,1);
        
        diffFeatureMatrixOne = extractDiffImageFeatures(imOneNormalized, imTwoNormalized, LabelsOne, numLabelsOne);
        
        relativeIntensityFeatureMatrixOne = extractRelativeIntensityFeatures(imOneNormalized, colorFeatureMatrixOne(1,:), ceil(colorFeatureMatrixOne(3,:)), ceil(colorFeatureMatrixOne(4,:)), numLabelsOne, 1);
        
        featureMatrixOfCurrentTripletOne = [colorFeatureMatrixOne; motionFeatureMatrixOne; diffFeatureMatrixOne; relativeIntensityFeatureMatrixOne];
        
        
        %% An idea to normalize features first Per Image
        featureMatrixOfCurrentTripletOne = normalizeFeatures(featureMatrixOfCurrentTripletOne);
        
        featureMatrix = [featureMatrix, featureMatrixOfCurrentTripletOne];
    end
    
    
    imageDictionary(num2str(imageNumber)) = imOneNormalized;
    labelsDictionary(num2str(imageNumber)) = LabelsOne;
    numLabelsDictionary(num2str(imageNumber)) = numLabelsOne;
    imageNamesDictionary(num2str(imageNumber)) = strcat(nameNoExt, ext);
    imageNumber = imageNumber+1;
    
    pathToLabelsFileTwo = fullfile(dirPath, 'slicZero', strcat(imZeroNameNoExt,'.tif'));
    LabelsTwo = imread(pathToLabelsFileTwo);
    %% LabelsTwo = dlmread(pathToLabelsFileTwo);
    numLabelsTwo = max(max(LabelsTwo));
    
    if(~featureMatrixExists)
        colorFeatureMatrixTwo = extractFeatures(imZeroNormalized, LabelsTwo, numLabelsTwo);
        
        neededName = nameNoExt;
        neededName(size(neededName,2)) = '0';
        motionFeatureMatrixTwo = extractMotionFeatures(imZeroNormalized, imTwoNormalized, LabelsTwo,numLabelsTwo, dirPath, imZeroNameNoExt,2);
        
        diffFeatureMatrixTwo = extractDiffImageFeatures(imZeroNormalized, imTwoNormalized, LabelsTwo, numLabelsTwo);
        
        relativeIntensityFeatureMatrixTwo = extractRelativeIntensityFeatures(imZeroNormalized, colorFeatureMatrixTwo(1,:), ceil(colorFeatureMatrixTwo(3,:)), ceil(colorFeatureMatrixTwo(4,:)), numLabelsTwo, 1);
        
        featureMatrixOfCurrentTripletTwo = [colorFeatureMatrixTwo; motionFeatureMatrixTwo; diffFeatureMatrixTwo; relativeIntensityFeatureMatrixTwo];
        
        
        %% An idea to normalize features first Per Image
        featureMatrixOfCurrentTripletTwo = normalizeFeatures(featureMatrixOfCurrentTripletTwo);
        
        %% visualizeFeatureMagnitudes(imZeroNormalized, featureMatrixOfCurrentTriplet, getFeatureNames(), Labels, colorFeatureMatrix(3,:), colorFeatureMatrix(4,:));
        
        %% featureMatrixOfCurrentTripletNormalized = normalizeFeaturesOfOneImage(featureMatrixOfCurrentTriplet);
        
        featureMatrix = [featureMatrix, featureMatrixOfCurrentTripletTwo];
    end
    
    imageDictionary(num2str(imageNumber)) = imTwoNormalized;
    labelsDictionary(num2str(imageNumber)) = LabelsTwo;
    numLabelsDictionary(num2str(imageNumber)) = numLabelsTwo;
    imageNamesDictionary(num2str(imageNumber)) = strcat(nameNoExt, ext);
    imageNumber = imageNumber+1;
    
    tripletsConsidered = tripletsConsidered+1;
    
end


if(~featureMatrixExists)
    savePath = fullfile(dirPath, 'featureMatrix.mat');
    save (savePath, 'featureMatrix');
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
%% SuperPixelClusterIndices = kmeans(featureMatrixCut', clusterNumber);

% EM algorithm expects columns as points
SuperPixelClusterIndices = emgm(featureMatrixCut, clusterNumber);


jackardSim = computeJackardSimilarity(labelsDictionary, numLabelsDictionary, imageNamesDictionary,SuperPixelClusterIndices, clusterNumber, dirPath);

figure();
bar(1:size(jackardSim,2), jackardSim);
title('Jackard Similarity');

% Sort, sorts ascendingly
[sortedJackardSimilarity sortedJackardIndices] = sort(jackardSim);
%% clustersToKeep = sortedJackardIndices(clusterNumber-1:clusterNumber);
clustersToKeep = sortedJackardIndices(clusterNumber);

% splits image superpixels belonging to different clusters to different
% figures
%%% visualizeClustersInSeparateImages(imageDictionary, labelsDictionary, numLabelsDictionary, SuperPixelClusterIndices, clusterNumber);

%%% visualizeClustersUsingAlphaBlending(imageDictionary, labelsDictionary, numLabelsDictionary, imageNamesDictionary, SuperPixelClusterIndices, 0.8, dirPath, '.tif', clustersToKeep);

featureMatrixSecondRound = [];
idxInOriginalFeatureMatrix = [];
for superpixelIdx = 1:size(featureMatrix,2)
    clusterIdx = SuperPixelClusterIndices(superpixelIdx);
    if( sum(clustersToKeep == clusterIdx) > 0)
        featureMatrixSecondRound = [featureMatrixSecondRound featureMatrix(:,superpixelIdx)];
        idxInOriginalFeatureMatrix = [idxInOriginalFeatureMatrix superpixelIdx];
    end
end

featureMatrixSecondRoundCut = featureMatrixSecondRound(featureToIncludeSecondRound > 0, :);
SuperPixelClusterIndicesSecondRound = emgm(featureMatrixSecondRoundCut, clusterNumberSecondRound);

SuperPixelClusterIndicesSecondRoundExpanded = zeros(1, size(SuperPixelClusterIndices,2));

SuperPixelClusterIndicesSecondRoundExpanded(idxInOriginalFeatureMatrix) = SuperPixelClusterIndicesSecondRound;


visualizeClustersUsingAlphaBlending(imageDictionary, labelsDictionary, numLabelsDictionary, imageNamesDictionary, SuperPixelClusterIndicesSecondRoundExpanded, 0.8, dirPath, '.tif', 1:clusterNumberSecondRound);

% Draw Histograms of features per cluster. Original (non-normalized)
% feature values are used
%% drawClusterHistograms(originalFeatureMatrixCut, featureNamesCut,  clusterNumber, SuperPixelClusterIndices);

% draw pairwise scatter plots of feature pairs
%% drawScatterPlots(originalFeatureMatrix, featureNames, SuperPixelClusterIndices);

% function expects that every row in featurematrix is a superpixel
%% pcaOnFeatureMatrix(featureMatrixCut', featureNamesCut, clusterNumber, SuperPixelClusterIndices);


end