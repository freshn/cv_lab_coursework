function pos = HarrisDetector(I1)
  % pos = HarrisDetector(I1)
  %
  % This fuction generates coordinates of I1.
  %
  % Paraments:
  % pos = n*2 position matrix.
  % I1 = rgb image in double data type.
 
  corners = detectHarrisFeatures(rgb2gray(I1),'MinQuality',0.015,...
       'ROI',[20,20,size(I1,2)-40,size(I1,1)-40],'FilterSize',5);
  corners = corners.selectStrongest(25);
  pos = corners.Location;
end