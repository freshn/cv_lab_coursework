clear;read_pic;

rt1 = gau_py(rooster);
rt2 = gau_py(rt1);
rt3 = gau_py(rt2);

figure(1),set(gcf,'position',[50,50,800,620]);
subplot(221),imagesc(rooster),colorbar;title('original pic');
subplot(222),imagesc(rt1),colorbar;title('half pic');
subplot(223),imagesc(rt2),colorbar;title('1/4 pic');
subplot(224),imagesc(rt3),colorbar;title('1/8 pic');
print -dpng q811.png

function Ia2 = gau_py(Ia1)
    g = fspecial('gaussian',6,1);
    Ia2 = imresize(conv2(Ia1,g,'same'),0.5,'nearest');
end

