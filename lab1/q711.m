clear;
rooster = imread('..\data\rooster.jpg');
rooster = im2double(rooster);
g1 = fspecial('gaussian',18,2);
g2 = fspecial('gaussian',18,3);

figure(1),set(gcf,'position',[50,50,800,620]);
rg(:,:,1) = conv2(rooster(:,:,1),g1,'same');
rg(:,:,2) = conv2(rooster(:,:,2),-g2,'same');
rg(:,:,3) = rooster(:,:,3);
subplot(221),imagesc(rg),colorbar;
title('red-on,green-off');

gr(:,:,1) = conv2(rooster(:,:,1),-g1,'same');
gr(:,:,2) = conv2(rooster(:,:,2),g2,'same');
gr(:,:,3) = rooster(:,:,3);
subplot(222),imagesc(gr),colorbar;
title('green-on,red-off');

y = mean(rooster(:,:,1:2),3);
by(:,:,3) = conv2(rooster(:,:,3),g1,'same');
by(:,:,1) = conv2(y,-g2,'same');
by(:,:,2) = conv2(y,-g2,'same');
subplot(223),imagesc(by),colorbar;
title('blue-on,yellow-off');

yb(:,:,3) = conv2(rooster(:,:,3),-g1,'same');
yb(:,:,1) = conv2(y,g2,'same');
yb(:,:,2) = conv2(y,g2,'same');
subplot(224),imagesc(yb),colorbar;
title('yellow-on,blue-off');

print -dpng q711.png
