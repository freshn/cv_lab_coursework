rooster = imread('..\data\rooster.jpg');
rooster = im2double(rooster);
rooster = rgb2gray(rooster);
boxes = imread('..\data\boxes.pgm');
boxes = im2double(boxes);
ele = imread('..\data\elephant.png');
ele = im2double(ele);