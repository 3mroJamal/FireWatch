% Function projects feature matrix into 2D space for vislualization

% Feature matrix is already normalized and contains only the features to be
% included in the clusters, featureMatrix rows correspond to superpixels

% pca(___) returns the principal component scores in score and the 
% principal component variances in latent. You can use any of the input 
% arguments in the previous syntaxes.
% Principal component scores are the representations of data matrix in the principal 
% component space. Rows of score correspond to observations, and columns correspond to components.
% The principal component variances are the eigenvalues of the covariance matrix of X.


function [] = pcaOnFeatureMatrix(featureMatrix ,featureNames, clusterNumber, clusterLabels)
    % Rows of X correspond to observations and columns correspond to variables.
    % The coefficient matrix is p-by-p. Each column of coeff contains coefficients for one principal component
    
    
    %% Samply only part of the data to make figures look better.
    numberOfSuperpixels = size(featureMatrix,1);
    cutOfIndices = 1:10:numberOfSuperpixels;
    featureMatrix = featureMatrix(cutOfIndices, :);
    clusterLabels = clusterLabels(cutOfIndices);
    
    [coeff,score,latent] = pca(featureMatrix);
    coeffCut = coeff(:,1:2);
    % need every row in coeffCUT to be a Principle Component, and each 
    % column in featureMatrix to be a datapoint
    projectedFeatureMatrix = coeffCut'*featureMatrix';
    projectedFeaturesOnFirstPC = projectedFeatureMatrix(1,:);
    projectedFeaturesOnSecondPC = projectedFeatureMatrix(2,:);
    
    size(projectedFeaturesOnFirstPC)
    size(clusterLabels)
    colorMap = generateColorMap();
    
    figure();
    for clusterIdx = 1:clusterNumber
        projectedFeaturesOnFirstPCInCluster = projectedFeaturesOnFirstPC(clusterLabels == clusterIdx);
        projectedFeaturesOnSecondPCInCluster = projectedFeaturesOnSecondPC(clusterLabels == clusterIdx);
        scatter(projectedFeaturesOnFirstPCInCluster, projectedFeaturesOnSecondPCInCluster, 25,colorMap(clusterIdx,:) );
        hold on;
    end
    xlabel('PC1');
    ylabel('PC2');
    title('scatter plot of projected data');
    
    
    
    %% Project data axes
    numberOfFeatures = size(featureMatrix, 2);
    dataAxes = zeros(numberOfFeatures);
    for i = 1:numberOfFeatures
        dataAxes(i,i) = 1;
    end
    projectedAxis = coeffCut'*dataAxes;
    
    for i = 1:numberOfFeatures
        hold on;
        quiver(0,0, projectedAxis(1,i) * 20, projectedAxis(2,i) * 20); 
        text(projectedAxis(1,i) * 20,projectedAxis(2,i) * 20, featureNames(i), 'FontSize', 12, 'FontWeight', 'bold');
    end
    
    
    
end