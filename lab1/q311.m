clear;read_pic;
bxmask5 = fspecial('average',5);
bxmask25 = fspecial('average',25);

figure(1);
subplot(221),imagesc(conv2(rooster,bxmask5,'same'));
colormap('gray'),colorbar;title('cov by box5');
subplot(222),imagesc(conv2(rooster,bxmask25,'same'));
colormap('gray'),colorbar;title('cov by box25');
subplot(223),imagesc(conv2(boxes,bxmask5,'same'));
colormap('gray'),colorbar;title('cov by box5');
subplot(224),imagesc(conv2(boxes,bxmask25,'same'));
colormap('gray'),colorbar;title('cov by box25');
print -dpng q311.png;
