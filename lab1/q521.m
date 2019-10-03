clear;read_pic;
l1 = -1/8.*[1 1 1;1 -8 1;1 1 1];
Gmask1 = fspecial('gaussian',[3 3],1.5);
Gmask2 = fspecial('gaussian',[3 3],5);
LoGmask1 = conv2(Gmask1,l1,'vaild');
LoGmask2 = conv2(Gmask2,l1,'vaild');
x = conv2(boxes,LoGmask1);
y = conv2(boxes,LoGmask2);

figure(1);set(gcf,'position',[50,50,800,620]);
subplot(221),mesh(LoGmask1);
subplot(223),imagesc(x);
colormap('jet'),colorbar;
subplot(222),mesh(LoGmask2);
subplot(224),imagesc(y);
colormap('jet'),colorbar;

max(x(:)) % 
max(y(:)) % 
