% Perform a function on a directory of triplets
% the function is perform on each triplet separately
% function is hardcoded inside this function
% TODO: allow this function to take the function to perform on each triplet
% as input

% Command: 

function [] = doFunctionOnImageDirectory(dirPath, tripletsCount)
    dirInfo = dir(dirPath)
    tripletsConsidered = 0;
  
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
          
            
            
            %% Put Your function Heree
            %% frameDifferenceTrial(imZero,imOne,imTwo);
            demoflow(imZero, imOne);
      end

end