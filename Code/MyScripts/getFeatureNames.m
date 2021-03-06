% returns hardcoded feature-names in a cell array. Whenver a new feature is
% added, this function must be updated with the new feature name.


% 'Motion Mean in X direction', 'Motion STD in X Direction', 'Motion Mean in Y Direction', 'Motion STD in Y Direction'

function [featureNames] = getFeatureNames()
    featureNames = {'Intensity Mean', 'Intensity STD', 'X-Position Of Superpixel', ...
        'Y-Position Of Superpixel',.... 
        'Motion Magnitude', 'Motion Magnitude STD', 'Motion Angle', 'Motion Angle STD', 'Diff Image Intensity Mean',...
        'Diff Image Intensity STD', 'relativeIntensityMean'};
    
end