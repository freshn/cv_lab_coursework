clc,clear
%��ȡ���ҶȻ�����ʾ
I1= im2double(imread('bikes/img1.png'));  
I1=rgb2gray(I1);  %��RGBͼ���ɻҶ�ͼ��
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
%��'Method','NearestNeighborSymmetric'����ֵ������'MatchThreshold',��Χ0-100����ʾѡ����ǿ��ƥ��İٷֱȣ�Խ��ƥ���Խ��
%��'Method','NearestNeighborRatio'����ֵ����'MaxRatio',0.7����Χ0-1��Ĭ��0.6���ϴ��ֵ��ý϶�ƥ��
matched_pts1 = vpts1(indexPairs(:, 1));
matched_pts2 = vpts2(indexPairs(:, 2));
 
resultpairs1 = matched_pts1.Location; %�洢ƥ�������
resultpairs2 = matched_pts2.Location;
 
%��ʾƥ��
figure('name','ƥ����ͼ��'); 
showMatchedFeatures(I1,I2,matched_pts1,matched_pts2,'montage');  
