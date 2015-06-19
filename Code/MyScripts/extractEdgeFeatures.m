function [] = extractEdgeFeatures(dirPath)
dirInfo = dir(dirPath);
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
        
        imZeroNormalized = normalizeImage(imZero);
        figure();
        imshow(imZeroNormalized);
       
        
        G = fspecial('gaussian',[10 10],1);
        %# Filter it
        IBlurred = imfilter(imZeroNormalized,G,'same');
        %# Display
        figure();
        imshow(IBlurred);
        title('Blurred');
        
        horizontalEdgeImage = imfilter(imZeroNormalized, [-1 0 1]);
        %%horizontalEdgeImage = normalizeImage(horizontalEdgeImage);
        figure();
        imshow(horizontalEdgeImage, [0, 0.1]);
        title('Horizontal Edges');
        class(horizontalEdgeImage)
        
        figure();
        imhist(horizontalEdgeImage);
        title('Horizontal Image Hist');
        
        
        verticalEdgeImage = imfilter(imZeroNormalized, [-1 0 1]');
        %% verticalEdgeImage = normalizeImage(verticalEdgeImage);
        figure();
        imshow(verticalEdgeImage, [0, 0.1]);
        title('vertical Edges');
        
        figure();
        imhist(verticalEdgeImage);
        title('Vertical Image Hist');
        
        
        edgeImageSobel = edge(imZeroNormalized, 'sobel', 0.005);  
        figure();
        imshow(edgeImageSobel);
        title('Sobel edges');
        
        
        edgeImageSobelBlurred = edge(IBlurred, 'sobel', 0.005);  
        figure();
        imshow(edgeImageSobelBlurred);
        title('Sobel edges Blurred');
        
        %% edgeImageCanny = edge(imZeroNormalized, 'Canny');
        %% figure();
        %% imshow(edgeImageCanny);
        
        
        %% edgeImagePrewitt = edge(imZeroNormalized, 'Prewitt');
        %% figure();
        %% imshow(edgeImagePrewitt);
        
        
    end
end
    
end