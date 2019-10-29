clear;read_pic;
gb1 = gabor2(4,8,90,0.5,0);
ele1 = conv2(ele,gb1,'valid');
gb2 = gabor2(4,8,90,0.5,90);
ele2 = conv2(ele,gb2,'valid');

cells = zeros(57,57,12);
for j = 0:15:165
        cells1(:,:,1+j/15) = gabor2(4,8,j,0.5,0);
        result1(:,:,1+j/15) = conv2(ele,cells1(:,:,1+j/15),'same');
end
for j = 0:15:165
        cells2(:,:,1+j/15) = gabor2(4,8,j,0.5,90);
        result2(:,:,1+j/15) = conv2(ele,cells2(:,:,1+j/15),'same');
end
results = cat(3,result1,result2);
%a = max(result1,[],3);
b = max(results,[],3);

figure(1),set(gcf,'position',[50,50,800,620]);
subplot(221),imagesc(ele1),colorbar;title('ele conv with gabor mask');
subplot(222),imagesc(sqrt(ele1.^2+ele2.^2)),colorbar;
title('ele conv with sqrt of 2 gabor mask');
subplot(223),imagesc(b),colorbar;
title('combination of gabor masks with different orients and phases');
%subplot(224),imagesc(a),colorbar;

print -dpng q531.png