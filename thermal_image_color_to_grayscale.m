clc;    
clear all;  
format long g;
format compact;
fontSize = 15;

baseFileName = 'thermal_image.png'; 
folder = pwd; 
fullFileName = fullfile(folder, baseFileName);  
fprintf('Transforming image "%s" to a thermal image.\n', fullFileName);

originalRGBImage = imread(fullFileName);
subplot(2, 3, 1);
imshow(originalRGBImage, []);
axis on;
caption = sprintf('Original Pseudocolor Image, %s', baseFileName);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Column', 'FontSize', fontSize, 'Interpreter', 'None');
ylabel('Row', 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;

grayImage = min(originalRGBImage, [], 3);
imageRow1 = 40;
imageRow2 = 298;
imageCol1 = 20;
imageCol2 = 460;
% Crop off the surrounding clutter to get the RGB image.
rgbImage = originalRGBImage(imageRow1 : imageRow2, imageCol1 : imageCol2, :);
% imcrop(originalRGBImage, [20, 40, 441, 259]);

% Next, crop out the colorbar.
colorBarRow1 = 45;
colorBarRow2 = 293;
colorBarCol1 = 533;
colorBarCol2 = 545;
% Crop off the surrounding clutter to get the colorbar.
colorBarImage = originalRGBImage(colorBarRow1 : colorBarRow2, colorBarCol1 : colorBarCol2, :);
b = colorBarImage(:,:,3);

subplot(2, 3, 2);
imshow(rgbImage, []);
axis on;
caption = sprintf('Cropped Pseudocolor Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Column', 'FontSize', fontSize, 'Interpreter', 'None');
ylabel('Row', 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo();

% Display the colorbar image.
subplot(2, 3, 3);
imshow(colorBarImage, []);
axis on;
caption = sprintf('Cropped Colorbar Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Column', 'FontSize', fontSize, 'Interpreter', 'None');
ylabel('Row', 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off')

storedColorMap = colorBarImage(:,1,:);
storedColorMap = double(squeeze(storedColorMap)) / 255;
storedColorMap = flipud(storedColorMap);

indexedImage = rgb2ind(rgbImage, storedColorMap);
subplot(2, 3, 4);
imshow(indexedImage, []);
axis on;
caption = sprintf('Indexed Image (Gray Scale Thermal Image)');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Column', 'FontSize', fontSize, 'Interpreter', 'None');
ylabel('Row', 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;

highTemp = 51.6;

lowTemp = 20.6;

% Scale the indexed gray scale image so that it's actual temperatures in degrees C instead of in gray scale indexes.
thermalImage = lowTemp + (highTemp - lowTemp) * mat2gray(indexedImage);

% Display the thermal image.
subplot(2, 3, 5);
imshow(thermalImage, []);
axis on;
colorbar;
title('Floating Point Thermal (Temperature) Image', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Column', 'FontSize', fontSize, 'Interpreter', 'None');
ylabel('Row', 'FontSize', fontSize, 'Interpreter', 'None');

hp = impixelinfo();
hp.Units = 'normalized';
hp.Position = [0.45, 0.03, 0.25, 0.05];

