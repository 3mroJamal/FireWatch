function [] = visualizeOpticalFlowArrows(Image, vx, vy)
    [r c] = size(Image);
    indices = r*c
    randIndices = randi([1 indices], 1, floor(indices/200));
    
    xVector = 1:c;
    xMatrix = repmat(xVector, r, 1);
    
    yVector = (1:r)';
    yMatrix = repmat(yVector, 1, c);
    
    neededX = xMatrix(randIndices);
    neededY = yMatrix(randIndices);
    
    neededXMotion = vx(randIndices);
    neededYMotion = vy(randIndices);
    
    
    figure();
    imshow(Image);
    title('many vectors');
    %% hold on;
    %% First Component, starts frop top left and goes right (horizontal)
    %% Second Component, starts from top left, and goes down (vertical)
    %% quiver(neededX, neededY,neededXMotion,neededYMotion);
    
    for i = 1:floor(indices/200)
        hold on;
        quiver(neededX(i), neededY(i),neededXMotion(i)*50,neededYMotion(i)*50);
    end
    
    %% figure(); imhist(neededXMotion); title('neededXMotion');
    
    %% figure(); imhist(neededYMotion); title('neededYMotion');
    
end