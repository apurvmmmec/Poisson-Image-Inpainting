close all;

imDest = im2double(rgb2gray(imread('hand.jpg')));
fig= figure();
set(fig, 'Position', [100, 100, 1000,600]);
subplot(2,2,1)
imshow(imDest);
title('Target Image');
drawnow;

imSource = im2double(rgb2gray(imread('eye.jpg')));
subplot(2,2,2)
imshow(imSource);
title('Source Image');
drawnow;

uiwait(msgbox('Please select a region in image using ROIPOLY tool','ROIPOLY','modal'));
srcMask = roipoly(imSource);
% imwrite(srcMask,'eyeMask.jpg');
title('Source Image');
subplot(2,2,3)
imshow(srcMask);
title('Mask Image');
drawnow;

%Offset for correct position of eye on hand
offset = [200 250];
[rDest cDest] = size(imDest);
destMask=resizeMaskToDest(srcMask,rDest,cDest,offset);

imOut = poissonSeamlessCloning(imSource, imDest, srcMask,destMask, offset);
subplot(2,2,4)
imshow(imOut);
title('Blended Image');
drawnow;