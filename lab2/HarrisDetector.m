function pos = HarrisDetector(I1)
  % pos = HarrisDetector(I1)
  %
  % This fuction generates coordinates of I1.
  %
  % Paraments:
  % pos = n*2 position matrix.
  % I1 = rgb image in double data type.
 
  corners = detectHarrisFeatures(rgb2gray(I1),'MinQuality',0.01);
%  number = size(corners.Location,1);
%  corners = corners.selectStrongest(round(number*0.8));
   corners = corners.selectStrongest(25);
  pos = corners.Location;
end