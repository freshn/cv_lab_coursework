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

   pt2_H = detectHarrisFeatures(rgb2gray(I2),'MinQuality',0.002);
   pt2_FAST = detectFASTFeatures(rgb2gray(I2),'MinQuality',0.002);
   pt2_ORB = detectORBFeatures(rgb2gray(I2));
   pt2_ORB = rb(pt2_ORB);
   pt2_BRISK = detectBRISKFeatures(rgb2gray(I2),'MinQuality',0.002);
%   pt2_BRISK = rb(pt2_BRISK);
   pt2_ME = detectMinEigenFeatures(rgb2gray(I2),'MinQuality',0.002);
disp(['pos1 numbers:' num2str(size(pos1,1))]);
  
%% extract features
  [f1, vpt1] = extf(I1, pt1);
  [f2_H, vpt2_H] = extf(I2, pt2_H); 
  [f2_FAST, vpt2_FAST] = extf(I2, pt2_FAST);
  [f2_ORB, vpt2_ORB] = extf(I2, pt2_ORB);  
%  [f2_BRISK, vpt2_BRISK] = extf(I2, pt2_BRISK); 
  [f2_ME, vpt2_ME] = extf(I2, pt2_ME);
  
%% matching
  [m1_H, m2_H] = match(f1, f2_H, vpt1, vpt2_H);
  [m1_FAST, m2_FAST] = match(f1, f2_FAST, vpt1, vpt2_FAST);
  [m1_ORB, m2_ORB] = match(f1, f2_ORB,vpt1, vpt2_ORB);
%  [m1_BRISK, m2_BRISK] = match(f1, f2_BRISK,vpt1, vpt2_BRISK);
  [m1_ME, m2_ME] = match(f1, f2_ME, vpt1, vpt2_ME);
%% correct error matches  
  [vm1_H, vm2_H] = vmatch(m1_H, m2_H);
  [vm1_FAST, vm2_FAST] = vmatch(m1_FAST, m2_FAST);
  [vm1_ORB, vm2_ORB] = vmatch(m1_ORB, m2_ORB);
%  [vm1_BRISK, vm2_BRISK] = vmatch(m1_BRISK, m2_BRISK);
  [vm1_ME, vm2_ME] = vmatch(m1_ME, m2_ME);

  vm1_list = {vm1_H, vm1_FAST, vm1_ORB, vm1_ME};
  vm2_list = {vm2_H, vm2_FAST, vm2_ORB, vm2_ME};
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
% extract features
    [feature, vpt] = extractFeatures(rgb2gray(I), pt,'FeatureSize',128);
end
function [matched1, matched2] = match(feature1, feature2, vpt1, vpt2)
% matching
    indexPairs = matchFeatures(feature1,feature2,'Method',...
      'NearestNeighborSymmetric','MatchThreshold',85);  
     matched1 = vpt1(indexPairs(:,1));
     matched2 = vpt2(indexPairs(:,2));  
end
function [vmatched1, vmatched2] = vmatch(m1, m2)
% find vaild matched
      [T,vmatched1,vmatched2,status] = estimateGeometricTransform...
      (m1,m2,'similarity','MaxNumTrials',4500,...
      'MaxDistance',9.5,'Confidence',70);
end
function pt = rb(pt_)
% rebuild cornerpoints for pt_
    pt = pt_.Location;
    pt = cornerPoints(pt);
end