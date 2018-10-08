close all;

%Read Image and convert it to Grayscale Image

%Choose any of the below image to experiment with
% imSrc = im2double(rgb2gray((imread('redfort.jpg'))));
imSrc = im2double(rgb2gray((imread('hand.jpg'))));

fig= figure();
set(fig, 'Position', [100, 100, 1000,600]);
subplot(2,2,1)
imshow(imSrc);
title('Input Image');
drawnow;

uiwait(msgbox('Please select a region in image using ROIPOLY tool','ROIPOLY','modal'));
imMask = roipoly(imSrc);
title('Input Image');
subplot(2,2,2)
imshow((imMask));
title('Mask');
drawnow;

fprintf('Solving Poison Equation for GrayScale Image\n');
tic
imOut = poissonHoleFilling(imSrc, imMask);
toc


subplot(2,2,[3 4])
imshow((imOut));
title('Hole Filled Image');
imwrite(imOut, 'task2Out.jpg');


