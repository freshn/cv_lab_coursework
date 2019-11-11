function [I1,I2] = read_img(fold)
  % [I1,I2] = read_img(fold)
  %
  % This fuction reads png or jpg images from certain fold.
  % 
  % Paraments:
  % I1 = first image.
  % I2 = second image.
  % fold = fold name in str.eg. 'bark'.

  
    if ~exist([fold,'/img1.png'],'file') == 0
        disp([fold,':png file']);
        I1 = im2double(imread([fold,'/img1.png']));
        I2 = im2double(imread([fold,'/img2.png']));
    else
        disp([fold,':jpg file']);
        I1 = im2double(imread([fold,'/img1.jpg']));
        I2 = im2double(imread([fold,'/img2.jpg']));
    end
end
