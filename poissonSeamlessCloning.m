function [imOut] = poissonSeamlessCloning(imSrc, imDest, srcMask,destMask, offset)

% imSrc - source image
% imDest - destination image
% srcMask - mask corresponding to source image
% destMask - mask corresponding to destination image
% offset - top left postion where the cloned image has to be positioned in
% destination

% Assumption is that the size of mask is equal to size of destination image
% and the mask has been offset to desirable location of destination image

tic


% Laplacian filter that is used to calculate laplacian of image
laplacian = [0 1 0; 1 -4 1; 0 1 0];

[hSrc wSrc] = size(imSrc);
[hDest wDest] = size(imDest);
[hMask wMask] = size(srcMask);

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

% calculate the laplacian image.
srcLap = conv2(imSrc, -laplacian, 'same');

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
            
            % The guidance field. It will the laplacian of he source image
            % pixel
            v = srcLap(y, x);
            
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


