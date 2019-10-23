clear;read_pic;

x = 0:1:30;
% size is the largest one given pixel_start and pixel_shifted
% this method make sure the two parts are as large as possible
r = part_corr(rooster,[1,1],x,min(size(rooster))-31);
w = part_corr(woods,[1,1],x,min(size(woods))-31);
figure(1),set(gcf,'position',[50,50,800,620]);
plot(x,r,x,w);   
title('corr of overlapping part'),xlabel('shifted pixels'),ylabel('correlation coefficient');
legend('rooster','woods')

print -dpng q611.png