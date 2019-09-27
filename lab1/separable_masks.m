mask1d = fspecial('gaussian',[1 60],10);
mask1d_extend = conv2(mask1d,mask1d','full');
mask2d = fspecial('gaussian',[60 60],10);

% separable mask
tic;
temp = conv2(rooster,mask1d);
conv2(temp,mask1d');
toc;
% 2d mask
tic;
conv2(rooster,mask2d);
toc;
