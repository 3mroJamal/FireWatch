%% computes slic labels for a directpry of triplets
% imageInTriplet =0 -> computes slic for zeroth image in triplet
% imageInTriplet =1 -> computes slic for first image
% imageInTriplet =2 -> computes slic for 2nd image
% stores results in local folders inside teh given directory
function [] = computeSlicForDirectory(dirPath, imageInTriplet)

dirInfo = dir(dirPath);

directoryName = '';
if(imageInTriplet ==0)
    directoryName = 'slicZero';
elseif (imageInTriplet ==1)
    directoryName = 'slicOne';
else directoryName = 'slicTwo';
end

slicDirPath = fullfile(dirPath, directoryName);

if exist(slicDirPath) == 7
    % remove directory with all subfolders 
    rmdir(slicDirPath, 's');
end
mkdir(slicDirPath);


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
        
        neededImage = [];
        if(imageInTriplet ==0)
            neededImage = imZeroNormalized;
        elseif(imageInTriplet ==1)
            neededImage = imOneNormalized;
        else
            neededImage = imTwoNormalized;
        end
        
        neededImageGrayScale = uint8(neededImage.*255);
        
        
        SuperPixelNumber = 500;
        CompactnessFactor = 40;
        [Labels, numLabels] = SLICdemo(neededImageGrayScale, SuperPixelNumber, CompactnessFactor);
        
        chosenDirectory = '';
        imageName = nameNoExt;
         if(imageInTriplet ==0)
             chosenDirectory = 'slicZero';
          elseif (imageInTriplet == 1)
             chosenDirectory = 'slicOne';
             imageName(size(imageName,2)) = '1';
         else
             chosenDirectory = 'slicTwo';
             imageName(size(imageName,2)) = '2';
         end  
         
        % convert them to uint16 to be able to write them as tif images
        Labels = uint16(Labels);
        writePath = fullfile(dirPath,chosenDirectory, strcat(imageName, '.tif'));
        %% dlmwrite(writePath,Labels);
        imwrite(Labels, writePath);

    end
end
end