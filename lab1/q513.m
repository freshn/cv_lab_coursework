clear;read_pic;
Gmask = fspecial('gaussian',9,1.5);
drvtmask = [-1 1];
Gdrvtmask1 = conv2(Gmask,drvtmask,'same');
Gdrvtmask2 = conv2(Gmask,drvtmask','same');
x1 = conv2(boxes,Gdrvtmask1,'same');
y1 = conv2(boxes,Gdrvtmask2,'same');
x2 = conv2(rooster,Gdrvtmask1,'same');
y2 = conv2(rooster,Gdrvtmask2,'same');

figure(1);set(gcf,'position',[50,50,800,300]);
subplot(121),imagesc(sqrt(x1.^2+y1.^2));
title('boxes conv with L2-norm mask');colormap('gray'),colorbar;
subplot(122),imagesc(sqrt(x2.^2+y2.^2));
title('rooster conv with L2-norm mask');colormap('gray'),colorbar
print -dpng q513.png 
