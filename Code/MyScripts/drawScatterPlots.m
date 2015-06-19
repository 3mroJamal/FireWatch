%% Draw Scatter plots for all pairs of features in feature Matrix, each column corresponds to a superpixel
%% originalFeatureMatrix: feature matrix with non-normalized values of each feature (features not having 0 mean and unit variance)
%% featureNames: names of features in a cell array


function [] = drawScatterPlots(originalFeatureMatrix, featureNames)



    for firstFeatureIdx = 1:size(featureNames,2)
        for secondFeatureIdx = firstFeatureIdx+1:size(featureNames,2)
            featureOneName = featureNames(firstFeatureIdx);
            featureTwoName = featureNames(secondFeatureIdx);
            featureOneValues = originalFeatureMatrix(firstFeatureIdx, :);
            featureTwoValues = originalFeatureMatrix(secondFeatureIdx, :);
        
            figure();
            scatter(featureOneValues, featureTwoValues);
            title(strcat(featureOneName, ' vs ', featureTwoName));
            xlabel(featureOneName);
            ylabel(featureTwoName);
        end
    end
end