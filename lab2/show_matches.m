function show_matches(I1,I2,pos1,pos2)
  % show_matches(fold)
  %
  % This fuction shows pos1 in I1 and their 
  % corresponding locationts in I2.
  % 
  % Paraments:
  % I1 = first image.
  % I2 = second image.
  % pos1 = n*2 feature points matrix.
    
    width = size(I1,2)*0.7;height = size(I1,1)*1.4;
    figure;set(gcf,'position',[500,0,width,height]);
    subplot(211);axis tight;
    set(gca,'YDir','reverse');
    imagesc(rgb2gray(I1));colormap('gray');hold on
    plot(pos1(:,1),pos1(:,2),'y+','LineWidth',2);
    subplot(212),imagesc(rgb2gray(I2));hold on
    plot(pos2(:,1),pos2(:,2),'y+','LineWidth',2);
end