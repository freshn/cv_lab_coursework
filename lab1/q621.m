clear;read_pic;

g1 = fspecial('gaussian',36,2);
g2 = fspecial('gaussian',36,6);
gm1 = g1-g2;
g3 = fspecial('gaussian',36,0.5);
g4 = fspecial('gaussian',36,4);
gm2 = g3-g4;

x = 0:1:30;
rooster1 = conv2(rooster,gm1,'same');
rooster2 = conv2(rooster,gm2,'same');
woods1 = conv2(woods,gm1,'same');
woods2 = conv2(woods,gm2,'same');
r1 = part_corr_x(rooster1,[1,1],x,size(rooster1,1)-31);
r2 = part_corr_x(rooster2,[1,1],x,size(rooster2,1)-31);
w1 = part_corr_x(woods1,[1,1],x,size(woods1,1)-31);
w2 = part_corr_x(woods2,[1,1],x,size(woods2,1)-31);

figure(1),set(gcf,'position',[50,50,800,310]);
subplot(121),plot(x,r1,x,w1);   
title('corr of overlapping part after conv by DoG1');
xlabel('shifted pixels'),ylabel('correlation coefficient');
legend('rooster','woods')
subplot(122),plot(x,r2,x,w2);   
title('corr of overlapping part after conv by DoG2');
xlabel('shifted pixels'),ylabel('correlation coefficient');
legend('rooster','woods')

print -dpng q621.png