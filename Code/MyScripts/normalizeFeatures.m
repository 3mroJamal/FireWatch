function featureMatrix = normalizeFeatures(featureMatrix)
  % normalize columns of feature matrix to zero mean and unit variance
  % featureMatrix is a matrix where every column represent an observation
  % and every row represents a feature
  featureMeans = mean(featureMatrix, 2);
  featureSTDs = std(featureMatrix')';
  [rows cols] = size(featureMatrix);
  MeanRepeated = repmat(featureMeans, 1, cols);
  
  STDRepeated = repmat(featureSTDs, 1, cols);
  
  
  
  featureMatrix = featureMatrix - MeanRepeated;
  
  featureMatrix = featureMatrix./STDRepeated;
end