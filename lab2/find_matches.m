function [pos2] = find_matches(I1, pos1, I2)
  %[pos2] = find_matches(I1, pos1, I2)
  %
  % This fuction finds corresponding locations in I2 
  % given certain coordinates pos1 in I1.
  %
  % Paraments:
  % pos2 = corresponding points' n*2 position matrix 
  % in second image.
  % I1 = rgb image in double data type.
  % pos1 = n*2 coordinates matrix.
  % I2 = rgb image in double data type(comparied image).
  
  pt1 = cornerPoints(pos1);
  pt2 = HarrisDetector(I2);
  pt2 = cornerPoints(pt2);
  
  % extract features
  [feature1, vpt1] = extractFeatures(rgb2gray(I2), pt1);
  [feature2, vpt2] = extractFeatures(rgb2gray(I2), pt2); 
    
  % matching
  indexPairs = matchFeatures(feature1,feature2,'Method',...
      'NearestNeighborSymmetric','MatchThreshold',20);
  matched1 = vpt1(indexPairs(:,1));
  matched2 = vpt2(indexPairs(:,2));  
  
  pos2 = matched2.Location;
  
  width = size(I1,2)*0.7;height = size(I1,1)*0.7;
  figure;set(gcf,'position',[500,0,width,height]);
  subplot(221);axis tight;
  set(gca,'YDir','reverse');
  imagesc(rgb2gray(I1));colormap('gray');hold on
  plot(pos1(:,1),pos1(:,2),'y+','LineWidth',2);
  subplot(222),imagesc(rgb2gray(I2));hold on
  plot(pos2(:,1),pos2(:,2),'y+','LineWidth',2);
  subplot(2,2,[3,4]),
  showMatchedFeatures(I1,I2,matched1,matched2,'montage');
end

