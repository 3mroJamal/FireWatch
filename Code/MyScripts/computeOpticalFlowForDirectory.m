%% Computes Optical flow for a directory of images
% if imagePair = 0, optical flow between images 0 and 1 is computed
% if imagePair = 1, optical flow between images 1 and 2 is computed
% if imagePair = 2, optical flow between images 1 and 3 is computed
% results are stored in a local folder inside the given directory

%% Sample Usage:
%% computeOpticalFlowForDirectory('D:\FireWatch\SampleImagesRaw\confirmedGermany\confirmedGermanyTrainAll\', 0)
function [] = computeOpticalFlowForDirectory(dirPath, imagePair)

dirInfo = dir(dirPath);
if(imagePair == 0)
    opticalFlowDirName = 'opticalFlowZeroOne';
elseif(imagePair == 1)
    opticalFlowDirName = 'opticalFlowOneTwo';
else
    opticalFlowDirName = 'opticalFlowZeroTwo';
end


opticalFlowDirPath = fullfile(dirPath, opticalFlowDirName);
if exist(opticalFlowDirPath) == 7
    % remove directory with all subfolders
    rmdir(opticalFlowDirPath, 's');
end
mkdir(opticalFlowDirPath);


for i = 3:size(dirInfo)
    
    [pathstr,nameNoExt,ext] = fileparts(dirInfo(i).name);
    if ~(isequal('.tif', ext) || isequal('.png', ext))
        continue;
    end
    
    
    
    lastCharacter = nameNoExt(size(nameNoExt,2));
    if(lastCharacter == '0')
        
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
        
        
        [imZeroNormalized, imOneNormalized, imTwoNormalized] = normalizeImage(imZero, imOne, imTwo);
        
        if(imagePair ==0)
            [vx,vy] = demoflow(imZeroNormalized, imOneNormalized);
            imageName = nameNoExt;
            dlmwrite(fullfile(opticalFlowDirPath, strcat(imageName, '_vx')),vx);
            dlmwrite(fullfile(opticalFlowDirPath, strcat(imageName, '_vy')),vy);
            
            figure();
            imhist(vx);
            title('vx');
            
            figure();
            imhist(vy);
            title('vy');
            
        elseif(imagePair ==1)
            [vx,vy] = demoflow(imOneNormalized, imTwoNormalized);
            imageName = nameNoExt;
            imageName(size(imageName,2)) = '1';
            dlmwrite(fullfile(opticalFlowDirPath, strcat(imageName, '_vx')),vx);
            dlmwrite(fullfile(opticalFlowDirPath, strcat(imageName, '_vy')),vy);
        else
            [vx,vy] = demoflow(imZeroNormalized, imTwoNormalized);
            imageName = nameNoExt;
            dlmwrite(fullfile(opticalFlowDirPath, strcat(imageName, '_vx')),vx);
            dlmwrite(fullfile(opticalFlowDirPath, strcat(imageName, '_vy')),vy);
        end
        
        
        
        
    end
end

end