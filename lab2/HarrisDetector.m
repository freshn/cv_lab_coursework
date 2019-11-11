function pos = HarrisDetector(I1)
  % pos = HarrisDetector(I1)
  %
  % This fuction generates coordinates of I1.
  % For clearly shown, only 0.9 strong corner points
  % are used.
  %
  % Paraments:
  % pos = n*2 position matrix.
  % I1 = rgb image in double data type.
 
  corners = detectHarrisFeatures(rgb2gray(I1),'MinQuality',0.15);
  number = size(corners.Location,1);
  corners = corners.selectStrongest(min(round(number*0.9),1000));
  pos = corners.Location;
end