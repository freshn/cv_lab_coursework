clc,clear
%读取、灰度化、显示
I1= im2double(imread('bikes/img1.png'));  
I1=rgb2gray(I1);  %把RGB图像变成灰度图像
% figure
% imshow(I1)
 
I2= im2double(imread('bikes/img2.png'));   
I2=rgb2gray(I2);
% figure
% imshow(I2)

points1 = detectHarrisFeatures(I1,'MinQuality',0.01);  
% points2 = detectSURFFeatures(I2);   
points2 = detectHarrisFeatures(I2,'MinQuality',0.01); 

%Extract the features.
[f1, vpts1] = extractFeatures(I1, points1);  
[f2, vpts2] = extractFeatures(I2, points2);  
 
%matching
indexPairs = matchFeatures(f1, f2,'Method','NearestNeighborSymmetric','MatchThreshold',10) ;  
%用'Method','NearestNeighborSymmetric'，阈值调节用'MatchThreshold',范围0-100，表示选择最强的匹配的百分比，越大匹配点越多
%用'Method','NearestNeighborRatio'，阈值调节'MaxRatio',0.7，范围0-1，默认0.6，较大该值获得较多匹配
matched_pts1 = vpts1(indexPairs(:, 1));
matched_pts2 = vpts2(indexPairs(:, 2));
 
resultpairs1 = matched_pts1.Location; %存储匹配点坐标
resultpairs2 = matched_pts2.Location;
 
%显示匹配
figure('name','匹配后的图像'); 
showMatchedFeatures(I1,I2,matched_pts1,matched_pts2,'montage');  
