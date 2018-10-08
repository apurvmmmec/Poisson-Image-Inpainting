function [imOut] = poissonHoleFilling(imDest, imMask)
% imDest - destination image
% imMask - mask of hole that needs to be filled

% Assumption is that the size of mask is equal to size of destination image
% and the mask has been offset to desirable location of destination image

[hDest wDest] = size(imDest);
[hMask wMask] = size(imMask);

%find the non-zero i.e white pixels of mask
n = size(find(imMask), 1); % n is number of non-zero pixels in mask

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
imMaskIdx = zeros(hDest, wDest);

count = 0;
for y = 1:hMask
    for x = 1:wMask
        if imMask(y, x) ~= 0
            count = count + 1;            
            imMaskIdx(y, x) = count;
        end
    end
end


   
row = 0; % row is the row index
for y = 1:hDest
    for x = 1:wDest

        % if the pixel is non-zero, then add to A matrix
        if imMask(y, x) ~= 0
            
            row = row + 1;   
            % Is top neighbour zero
            if imMask(y-1, x) ~= 0
                col = imMaskIdx(y-1, x);
                A(row, col) = -1;
            else % top neighbour is at boundary
                B(row) = B(row) + imDest(y-1, x);
            end
            
            % Is bottom neighbour zero
            if imMask(y+1, x) ~= 0
                col = imMaskIdx(y+1, x);
                A(row, col) = -1;
            else    % bottom neighbour is at boundary
                B(row) = B(row) + imDest(y+1, x);
            end
            
            % Is left neighbour zero
            if imMask(y, x-1) ~= 0
                col = imMaskIdx(y, x-1);
                A(row, col) = -1;
            else % left neighbour is at boundary
                B(row) = B(row) + imDest(y, x-1);
            end            
            
            % Is right neighbour zero
            if imMask(y, x+1) ~= 0
                col = imMaskIdx(y, x+1);
                A(row, col) = -1;
            else    % right neighbour is at boundary
                B(row) = B(row) + imDest(y, x+1);
            end       
            
            A(row, row) = 4;
            % The guidance field for task 2 is considered 0 as we are just 
            % filling the mask with help of boundary value
            v = 0;
            
            % Guidance field is added to boundary value , but here its zero
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
        if imMask(y1, x1) ~= 0
            idx=idx+1;
            imOut(y1, x1) = x(idx);
        end
    end
end

