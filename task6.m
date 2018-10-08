close all;
imDest = im2double(imread('sunflower.jpg'));
imDestGray = rgb2gray(imDest);
fig= figure();
set(fig, 'Position', [100, 100, 1000,600]);
subplot(2,2,1)
imshow(imDest);
title('Target Image');
drawnow;

% Here the source image will be same as destination image because we are
% just changing the colour of a selected region of same image
imSource = imDest;

srcMask = imread('sunflowerMask.png');

% If you dont want to use a pre-created mask, please uncomment below code
% of using roipoly and create a mask of your choice.

% figure;
% uiwait(msgbox('Please select a region in image usning ROIPOLY tool','ROIPOLY','modal'));
% srcMask = roipoly(imSource);

subplot(2,2,3)
imshow(srcMask);
title('Mask Image');
drawnow;

[row, col] = find(srcMask);

%clalc bounding box of mask in source image
bbMin = [min(col), min(row)];
offset = [bbMin(1) bbMin(2)];

imDestR = imDest(:, :, 1);
imDestG = imDest(:, :, 2);
imDestB = imDest(:, :, 3);

imSourceR = imSource(:, :, 1);
imSourceG = imSource(:, :, 2);
imSourceB = imSource(:, :, 3);

fprintf('Solving for red Channel\n');
imOutR = poissonColorMod(imSourceR, imDestR,imDestGray, srcMask, offset);

fprintf('Solving for green Channel\n');
imOutG = poissonColorMod(imSourceG, imDestG,imDestGray, srcMask, offset);

fprintf('Solving for blue Channel\n');
imOutB = poissonColorMod(imSourceB, imDestB,imDestGray, srcMask, offset);

[rows cols] = size(imOutR);
imgOut = zeros(rows, cols, 3);

imgOut(:, :, 1) = imOutR;
imgOut(:, :, 2) = imOutG;
imgOut(:, :, 3) = imOutB;


subplot(2,2,[2 4])
imshow(imgOut);
title('Edited Image');
% imwrite(imgOut,'decoloredSunflower.jpg');


