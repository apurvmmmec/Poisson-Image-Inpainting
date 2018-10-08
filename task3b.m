close all;
% imDest = im2double(imread('livingRoom.jpg'));
imDest = im2double(imread('whiteWall.jpg'));

fig= figure();
set(fig, 'Position', [100, 100, 1000,600]);
subplot(2,2,1)
imshow(imDest);
title('Target Image');
drawnow;



% imSource = im2double(imread('butterflies.jpg'));
imSource = im2double(imread('textUCL.jpg'));

subplot(2,2,2)
imshow(imSource);
title('Source Image');
drawnow;

uiwait(msgbox('Please select a region in image usning ROIPOLY tool','ROIPOLY','modal'));
srcMask = roipoly(imSource);
title('Source Image');
subplot(2,2,3)
imshow(srcMask);
title('Mask Image');
drawnow;

% Offset for butterflies on Wall
offset = [480 150];

% Offset for text on White Wall
offset = [230 350];

[rDest cDest ~] = size(imDest);
destMask=resizeMaskToDest(srcMask,rDest,cDest,offset);

imDestR = imDest(:, :, 1);
imDestG = imDest(:, :, 2);
imDestB = imDest(:, :, 3);

imSourceR = imSource(:, :, 1);
imSourceG = imSource(:, :, 2);
imSourceB = imSource(:, :, 3);

fprintf('Solving for red Channel\n');
imOutR = poissonGradientMixing(imSourceR, imDestR, srcMask,destMask, offset);

fprintf('Solving for green Channel\n');
imOutG = poissonGradientMixing(imSourceG, imDestG, srcMask,destMask, offset);

fprintf('Solving for blue Channel\n');
imOutB = poissonGradientMixing(imSourceB, imDestB, srcMask,destMask, offset);

[rows cols] = size(imOutR);
imgOut = zeros(rows, cols, 3);

imgOut(:, :, 1) = imOutR;
imgOut(:, :, 2) = imOutG;
imgOut(:, :, 3) = imOutB;

subplot(2,2,4)
imshow(imgOut);
title('Blended Image');
drawnow;