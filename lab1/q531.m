clear;read_pic;
gb1 = gabor2(4,8,90,0.5,0);
ele1 = conv2(ele,gb1,'valid');
gb2 = gabor2(4,8,90,0.5,90);
ele2 = conv2(ele,gb2,'valid');

cells = zeros(57,57,12);
for j = 0:15:165
        cells(:,:,1+j/15) = gabor2(4,8,j,0.5,0);
end
a = max(cells,[],3);

figure(1),set(gcf,'position',[50,50,800,620]);
subplot(221),imagesc(ele1),colorbar;
subplot(222),imagesc(sqrt(ele1.^2+ele2.^2)),colorbar;
subplot(223),imagesc(a),colorbar;

print -dpng q531.png