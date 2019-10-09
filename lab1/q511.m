clear;read_pic;
Gmask = fspecial('gaussian',7,5);
drvtmask = [-1 1];
Gdrvtmask1 = conv2(Gmask,drvtmask);
Gdrvtmask2 = conv2(Gmask,drvtmask');
x = conv2(boxes,Gdrvtmask1);
y = conv2(boxes,Gdrvtmask2);

figure(1);set(gcf,'position',[50,50,800,620]);
subplot(221),mesh(Gdrvtmask1);
title('Gaussian derivative mask(x)');
subplot(222),mesh(Gdrvtmask2);
title('Gaussian derivative mask(y)');
subplot(223),imagesc(x);
title('conv with Gaussian derivative mask(x)');colormap('jet'),colorbar
subplot(224),imagesc(y);
title('conv with Gaussian derivative mask(y)');colormap('jet'),colorbar
print -dpng q511.png 

max(x(:)) % 0.1544
max(y(:)) % 0.1544