clear;read_pic;

x = 0:1:30;
% size is the largest one given pixel_start and pixel_shifted
% this method make sure the two parts are as large as possible
rls = size(rooster,1)-31;
wls = size(woods,1)-31;
r = part_corr_x(rooster,[1,1],x,rls);
w = part_corr_x(woods,[1,1],x,wls);
figure(1),set(gcf,'position',[50,50,800,620]);
plot(x,r,x,w);   
title('corr of overlapping part'),xlabel('shifted pixels'),ylabel('correlation coefficient');
legend('rooster','woods')

print -dpng q611.png