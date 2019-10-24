clear;read_pic;
rooster_lapl = lapl(rooster);
rt1 = gau_py(rooster);
rt1_lapl = lapl(rt1);
rt2 = gau_py(rt1);
rt2_lapl = lapl(rt2);
rt3 = gau_py(rt2);
rt3_lapl = lapl(rt3);

figure(1),set(gcf,'position',[50,50,800,620]);
subplot(221),imagesc(rooster_lapl),colorbar;title('original pic');
subplot(222),imagesc(rt1_lapl),colorbar;title('half pic');
subplot(223),imagesc(rt2_lapl),colorbar;title('1/4 pic');
subplot(224),imagesc(rt3_lapl),colorbar;title('1/8 pic');
print -dpng q821.png

function Ia2 = gau_py(Ia1)
    g = fspecial('gaussian',6,1);
    Ia2 = imresize(conv2(Ia1,g,'same'),0.5,'nearest');
end

function Ia2 = lapl(Ia1)
    g = fspecial('gaussian',6,1);
    Ia0 = conv2(Ia1,g,'same');
    Ia2 = Ia1-Ia0;
end