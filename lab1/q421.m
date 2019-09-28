clear;read_pic
l1 = -1/8.*[1 1 1;1 -8 1;1 1 1];
l2 = -[1 1 1;1 -8 1;1 1 1];

conv1 = conv2(boxes,l1);
conv2 = conv2(boxes,l2);
figure(1);set(gcf,'position',[50,50,1300,500]);
subplot(121),imagesc(conv1);colorbar;
subplot(122),imagesc(conv2);colorbar;
print -dpng q421.png 