function [vx,vy] = demoflow(im1, im2)



im1 = normalizeImage(im1);
im2 = normalizeImage(im2);

im1 = repmat(im1,1,1,3);
im2 = repmat(im2,1,1,3);




% im1 = imresize(im1,0.5,'bicubic');
% im2 = imresize(im2,0.5,'bicubic');

% set optical flow parameters (see Coarse2FineTwoFrames.m for the definition of the parameters)
%alpha = 0.012;
alpha = 0.012;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
%% nSORIterations = 15;

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

% this is the core part of calling the mexed dll file for computing optical flow
% it also returns the time that is needed for two-frame estimation

%% warpI2 is image2 reconstructed from imageOne and motion vectors
tic;
[vx,vy,warpI2] = Coarse2FineTwoFrames(im1,im2,para);
toc

figure;imshow(im1);title('Image One');

figure;imshow(im2);title('Image Two');

%%%%%%%%%% figure;imshow(warpI2); title('warpI2');



% output gif
%% clear volume;
%%volume(:,:,:,1) = im1;
%%volume(:,:,:,2) = im2;
%%if exist('output','dir')~=7
%%    mkdir('output');
%%end
%%frame2gif(volume,fullfile('output',[example '_input.gif']));
%%volume(:,:,:,2) = warpI2;
%%frame2gif(volume,fullfile('output',[example '_warp.gif']));


% visualize flow field
clear flow;
flow(:,:,1) = vx;
flow(:,:,2) = vy;

imflow = flowToColor(flow);

figure;imshow(imflow); title('imFlow');
%% imwrite(imflow,fullfile('output',[example '_flow.jpg']),'quality',100);

[rows, cols, depth] = size(im1)
rowsMatrix = zeros(rows, cols);

 for i = 1:rows
    rowsMatrix(i,:) = i;
 end
    
 columnMatrix = zeros(rows, cols);
 for j = 1:cols
    columnMatrix(:,j) = j;
 end
 

indices = rows*cols;
randIndices = randi([1 indices], 1, floor(indices/100));
    
   
neededX = rowsMatrix(randIndices);
neededY = columnMatrix(randIndices);

    
neededXMotion = vx(randIndices);
neededYMotion = vy(randIndices);

figure();
imshow(normalizeImage(rgb2gray(im1)));
hold on;
quiver(neededY, neededX , neededXMotion, neededYMotion);

title('random vectors');

%%figure();
%%imhist(neededXMotion);
%%title('Motion in X');

%%figure();
%%imhist(neededYMotion);
%%title('Motion in Y');





end
