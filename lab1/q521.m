clear;read_pic;
l1 = -1/8.*[1 1 1;1 -8 1;1 1 1];
Gmask1 = fspecial('gaussian',7,1.5);
Gmask2 = fspecial('gaussian',7,5);
LoGmask1 = conv2(Gmask1,l1,'valid');
LoGmask2 = conv2(Gmask2,l1,'valid');
x = conv2(boxes,LoGmask1);
y = conv2(boxes,LoGmask2);

figure(1);set(gcf,'position',[50,50,800,620]);
subplot(221),mesh(LoGmask1);title('LoG mask from Gmask1.5');
subplot(223),imagesc(x);title('conv from LoG1.5');
colormap('jet'),colorbar;
subplot(222),mesh(LoGmask2);title('LoG mask from Gmask5');
subplot(224),imagesc(y);title('conv from LoG5');
colormap('jet'),colorbar;
print -dpng q521.png

max(x(:)) % 0.1061
max(y(:)) % 0.0150