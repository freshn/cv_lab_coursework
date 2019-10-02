clear;read_pic;
gaussian1_5 = fspecial('gaussian',[25 25],1.5);
gaussian10 = fspecial('gaussian',[25 25],10);

figure(2);set(gcf,'position',[50,50,800,620]);
subplot(221),imagesc(conv2(rooster,gaussian1_5,'same'));
colormap('gray'),colorbar;title('conv by gaussian1.5');
subplot(222),imagesc(conv2(rooster,gaussian10,'same'));
colormap('gray'),colorbar;title('conv by gaussian10');
subplot(223),imagesc(conv2(boxes,gaussian1_5,'same'));
colormap('gray'),colorbar;title('conv by gaussian1.5');
subplot(224),imagesc(conv2(boxes,gaussian10,'same'));
colormap('gray'),colorbar;title('conv by gaussian10');
print -dpng q321.png;