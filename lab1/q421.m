clear;read_pic;
l1 = -1/8.*[1 1 1;1 -8 1;1 1 1];
l2 = -[1 1 1;1 -8 1;1 1 1];

conv1 = conv2(boxes,l1);
conv2 = conv2(boxes,l2);
figure(1);set(gcf,'position',[50,50,800,620]);
subplot(221),imagesc(conv1);title('original pic via 1st Laplacian mask');colorbar;
subplot(222),imagesc(conv2);title('original pic via 2nd Laplacian mask');colorbar;
subplot(223),imagesc(conv1(20:30,60:70));title('partial pic via 1st Laplacian mask');colorbar;
subplot(224),imagesc(conv2(20:30,60:70));title('partial pic via 2nd Laplacian mask');colorbar;
print -dpng q421.png 