% normalize columns of feature matrix to zero mean and unit variance
% featureMatrix is a matrix where every column represent an observation
% and every row represents a feature

function featureMatrix = normalizeFeatures(featureMatrix)

  %% one idea is to normalize features to have be in [0,1]
  %% minValue = min(featureMatrix')';
  %% maxValue = max(featureMatrix')';
  %% range = maxValue - minValue;
  %% minRepeated = repmat(minValue,1, size(featureMatrix,2));
  %% rangeRepeated = repmat(range,1, size(featureMatrix,2)); 
  %% featureMatrixShifted = featureMatrix - minRepeated;
  %% featureMatrix = featureMatrixShifted./rangeRepeated;

  featureMeans = mean(featureMatrix, 2);
  featureSTDs = std(featureMatrix')';
  [rows cols] = size(featureMatrix);
  MeanRepeated = repmat(featureMeans, 1, cols);
  
  STDRepeated = repmat(featureSTDs, 1, cols);
 
  featureMatrix = featureMatrix - MeanRepeated;
  
  featureMatrix = featureMatrix./STDRepeated;
end