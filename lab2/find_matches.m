function [pos2,acc] = find_matches(I1, pos1, I2)
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
 
%% build cornerpoints for pos1
   pt1 = cornerPoints(pos1);
% fake match
%  pt2 = HarrisDetector(I2);
%  pt2 = cornerPoints(pt2);
%   pt1 = detectHarrisFeatures(rgb2gray(I1),'MinQuality',0.002);
%   pt1 = pt1.selectStrongest(size(pos1,1));

   pt2 = detectHarrisFeatures(rgb2gray(I2),'MinQuality',0.002);
%    pt2 = detectFASTFeatures(rgb2gray(I2),'MinQuality',0.002);
    pt2_ORB = detectORBFeatures(rgb2gray(I2));
% rebuild cornerpoints for pos2
   pt2_ORB = pt2_ORB.Location;
   pt2_ORB = cornerPoints(pt2_ORB);
disp(['pos1 numbers:' num2str(size(pos1,1))]);
  
%% extract features
  [f1, vpt1] = extf(I1, pt1);
  [f2, vpt2] = extf(I2, pt2); 
  [f2_ORB, vpt2_ORB] = extf(I2, pt2_ORB);  
  
%% matching
  [m1, m2] = match(f1, f2, vpt1, vpt2);
  [m1_ORB, m2_ORB] = match(f1, f2_ORB,vpt1, vpt2_ORB);
 
%% correct error matches  
  [vm1_H, vm2_H] = vmatch(m1, m2);
  [vm1_ORB, vm2_ORB] = vmatch(m1_ORB, m2_ORB);

%   if size(vm1_H,1) < size(vm1_ORB,1)
%       vm1 = vm1_ORB;
%       vm2 = vm2_ORB;
%   else
%       vm1 = vm1_H;
%       vm2 = vm2_H;
%   end    
  vm1_list = {vm1_H, vm1_ORB};
  vm2_list = {vm2_H, vm2_ORB};
  a = 0;
  for i = 1:length(vm1_list)
      if size(vm1_list{i},1)>a
          a = size(vm1_list{i},1);
          vm1 = vm1_list{i};
          vm2 = vm2_list{i};
      end 
  end     
  
  disp(['matched numbers:' num2str(size(vm1,1)) 10]);
  acc = size(vm1,1)/size(pos1,1);
 
%% return pos2  
  pos2 = vm2.Location;
 
%% show matches 
  width = size(I1,2)*0.7;height = size(I1,1)*0.7;
  figure;set(gcf,'position',[500,0,width,height]);
  subplot(221);axis tight;
  set(gca,'YDir','reverse');
  imagesc(rgb2gray(I1));colormap('gray');hold on
  plot(pos1(:,1),pos1(:,2),'y+','LineWidth',2);
  subplot(222),imagesc(rgb2gray(I2));hold on
  plot(pos2(:,1),pos2(:,2),'y+','LineWidth',2);
  subplot(2,2,[3,4]),
  showMatchedFeatures(I1,I2,vm1,vm2,'montage');
end

%% utlization
function [feature, vpt] = extf(I, pt)
    [feature, vpt] = extractFeatures(rgb2gray(I), pt,'FeatureSize',128);
end
function [matched1, matched2] = match(feature1, feature2, vpt1, vpt2)
     indexPairs = matchFeatures(feature1,feature2,'Method',...
      'NearestNeighborSymmetric','MatchThreshold',85);  
     matched1 = vpt1(indexPairs(:,1));
     matched2 = vpt2(indexPairs(:,2));  
end
function [vmatched1, vmatched2] = vmatch(m1, m2)
      [T,vmatched1,vmatched2] = estimateGeometricTransform...
      (m1,m2,'similarity','MaxNumTrials',4500,...
      'MaxDistance',9.5,'Confidence',70);
end