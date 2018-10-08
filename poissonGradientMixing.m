function [imOut] = poissonGradientMixing(imSrc, imDest, srcMask,destMask, offset)
% imSrc - source image
% imDest - destination image
% srcMask - mask corresponding to source image
% destMask - mask corresponding to destination image
% offset - top left postion where the cloned image has to be positioned in
% destination

% Assumption is that the size of mask is equal to size of destination image
% and the mask has been offset to desirable location of destination image

tic

laplacian = [0 1 0; 1 -4 1; 0 1 0];

% height and width of both the source image and the destination image
[hSrc wSrc] = size(imSrc);
[hDest wDest] = size(imDest);
[hMask wMask] = size(srcMask);

% the offset between the source and the destination
xoff = offset(1);
yoff = offset(2);





%find the non-zero i.e white pixels of mask
n = size(find(srcMask), 1); % n is number of non-zero pixels in mask

% pre-allocation of memory. Since A sparce matrix, most elements will
%be zero, so using spalloc. Since we consider 4 neighbours of each pixel,
% so max of 5 non-zero elements will be there in each row, so for n rows 
% 5*n non-zero elements.
A = sparse(n, n, 5*n);    

% Column vector to store boundary values
B = zeros(n, 1);
% Guidance vector field
v= 0;

% Itearate through Mask and Store the indices of all non-zero elemnts of 
% the mask in a separate marix
imMaskIdx = zeros(hMask, wMask);

count = 0;
for y = 1:hMask
    for x = 1:wMask
        if srcMask(y, x) ~= 0
            count = count + 1;            
            imMaskIdx(y, x) = count;
        end
    end
end

[row, col] = find(srcMask);
%calculate bounding box of mask in source image
bbMin = [min(col), min(row)];


row = 0;
for y = 1:hSrc
    for x = 1:wSrc
        
        % Check if pixel falls in masked region
        if srcMask(y, x) ~= 0
            
            row = row + 1;
            
            % position in the destination image
            yNew = y + yoff-bbMin(2);
            xNew = x + xoff-bbMin(1);
            
            
            % Is top neighbour zero
            if srcMask(y-1, x) ~= 0
                col = imMaskIdx(y-1, x);
                A(row, col) = -1;
            else % top neighbour is at boundary
                B(row) = B(row) + imDest(yNew-1, xNew);
            end
            
            % Is bottom neighbour zero
            if srcMask(y+1, x) ~= 0
                col = imMaskIdx(y+1, x);
                A(row, col) = -1;
            else    % bottom neighbour is at boundary
                B(row) = B(row) + imDest(yNew+1, xNew);
            end
            
            % Is left neighbour zero
            if srcMask(y, x-1) ~= 0
                col = imMaskIdx(y, x-1);
                A(row, col) = -1;
            else % left neighbour is at boundary
                B(row) = B(row) + imDest(yNew, xNew-1);
            end            
            
            % Is right neighbour zero
            if srcMask(y, x+1) ~= 0
                col = imMaskIdx(y, x+1);
                A(row, col) = -1;
            else    % right neighbour is at boundary
                B(row) = B(row) + imDest(yNew, xNew+1);
            end       
            
            A(row, row) = 4;
            
            % For gradient mixing we calculate all 4 gradients of pixel
            % with it neighbours for destination image
            %fpq = |fp-fq|
            
            fpq1 = imDest(yNew, xNew) - imDest(yNew-1, xNew);
            fpq2 = imDest(yNew, xNew) - imDest(yNew+1, xNew);
            fpq3 = imDest(yNew, xNew) - imDest(yNew, xNew-1);
            fpq4 = imDest(yNew, xNew) - imDest(yNew, xNew+1);
             
            % For gradient mixing we calculate all 4 gradients of pixel
            % with it neighbours for source image
            %gpq = |gp - gq |
            gpq1 = imSrc(y, x) - imSrc(y-1, x);
            gpq2 = imSrc(y, x) - imSrc(y+1, x);
            gpq3 = imSrc(y, x) - imSrc(y, x-1);
            gpq4 = imSrc(y, x) - imSrc(y, x+1);
            
            v = 0;
            % Now we calculate the guiding vector based on gradients of
            % source and dest image
            
            % We check that at current pixel, if gradient of dest image
            % is stronger than the source image, we choose the dest else
            % source. We do this using magnitude/abs val of gradient and
            % for each neighbour of pixel.
            
            if abs(fpq1) > abs(gpq1)
                v = v + fpq1;
            else
                v = v + gpq1;
            end
            
            if abs(fpq2) > abs(gpq2)
                v = v + fpq2;
            else
                v = v + gpq2;
            end
            
            if abs(fpq3) > abs(gpq3)
                v = v + fpq3;
            else
                v = v + gpq3;
            end
            
            if abs(fpq4) > abs(gpq4)
                v = v + fpq4;
            else
                v = v + gpq4;
            end
            
            
            
            B(row) = B(row)+v;
            
        end
    end
end


% solve the SLE for x
x= A\B;


%Copy destination image to output and then take value of masked pixels from
% the solution x that we got above
imOut = imDest;
idx=0;
for y1 = 1:hDest
    for x1 = 1:wDest
        if destMask(y1, x1) ~= 0
            idx=idx+1;
            imOut(y1, x1) = x(idx);
        end
    end
end
toc