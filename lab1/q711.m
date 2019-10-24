clear;
rooster = imread('..\data\rooster.jpg');
rooster = im2double(rooster);
g1 = fspecial('gaussian',18,2);
g2 = fspecial('gaussian',18,3);