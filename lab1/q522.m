clear;read_pic;
l1 = -1/8.*[1 1 1;1 -8 1;1 1 1];
Gmask1 = fspecial('gaussian',9,1.5);
Gmask2 = fspecial('gaussian',9,5);
LoGmask1 = conv2(Gmask1,l1,'valid');
LoGmask2 = conv2(Gmask2,l1,'valid');
x = conv2(rooster,LoGmask1);
y = conv2(rooster,LoGmask2);

figure(1);set(gcf,'position',[50,50,800,310]);
subplot(121),imagesc(x);title('conv from LoG1.5');
colormap('jet'),colorbar;
subplot(122),imagesc(y);title('conv from LoG5');
colormap('jet'),colorbar;
print -dpng q522.png
