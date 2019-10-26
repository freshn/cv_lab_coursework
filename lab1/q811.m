clear;read_pic;

rt1 = gau_py(rooster);
rt2 = gau_py(rt1);
rt3 = gau_py(rt2);

figure(1),set(gcf,'position',[50,50,800,620]);colormap('gray');
subplot(221),imagesc(rooster),colorbar;title('Gaussian Pyramids 1');
subplot(222),imagesc(rt1),colorbar;title('Gaussian Pyramids 2');
subplot(223),imagesc(rt2),colorbar;title('Gaussian Pyramids 3');
subplot(224),imagesc(rt3),colorbar;title('Gaussian Pyramids 4');
print -dpng q811.png

function Ia2 = gau_py(Ia1)
    g = fspecial('gaussian',6,1);
    Ia2 = imresize(conv2(Ia1,g,'same'),0.5,'nearest');
end

