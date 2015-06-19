% equalizeImagesInDirectory: normalizes Images in "srcDirectoryPath" to 
% grayscale [0,255] and then performs adaptive histogram equalization and
% saves reulting images in "destinationDirectoryPath"
% IMPORTANT FOR DATA VISUALIZATION

%% Sample Command
%% equalizeImagesInDirectory('D:\FireWatch\SampleImagesRaw\confirmedGermany\confirmedGermanyTrainAll\','D:\FireWatch\EqualizedImages\confirmedGermany\confirmedGermanyTrainAll\');

function [] = equalizeImagesInDirectory(srcDirectoryPath, destinationDirectoryPath)
    if(srcDirectoryPath == destinationDirectoryPath)
        disp('directories are the same, cant create the images');
        return;
    end
    
    dirInfo = dir(srcDirectoryPath);
  
    for i = 3:size(dirInfo)
      
        [pathstr,nameNoExt,ext] = fileparts(dirInfo(i).name);
        if ~(isequal('.tif', ext) || isequal('.png', ext))
            continue;
        end
        
        imageName = strcat(nameNoExt, ext);
        imagePath = fullfile(srcDirectoryPath,imageName);
        image = imread(imagePath);
        
        normalizedImage = uint8(normalizeImage(image).*255);
        AdaptiveEqualizedImage = adapthisteq(normalizedImage);
        
        newImageName = strcat(nameNoExt, '_equalized', ext);
        newImagePath = fullfile(destinationDirectoryPath, newImageName);
        
        imwrite(AdaptiveEqualizedImage, newImagePath);
        
    end
end