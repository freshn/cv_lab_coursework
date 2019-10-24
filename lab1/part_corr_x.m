function part_corr_x = part_corr_x(image, pixel_start, pixel_shifted, sz)
  %corr_value = part_corr(image, pixel_start, size, piexl_shifted)
  %
  % This fuction calculates the correlation coefficients between 
  % overlapping parts of the same image shifted by different values.
  % 
  % Paraments:
  % image = gray original image
  % pixel_start = top lift piexl of the first image part
  % pixel_shifted = how many piexls shifted
  % size = size of image part

    if nargin < 4
       sz = 70;
    end        
    column = size(image,2);
    for i = 1:1:length(pixel_shifted)
        p1 = image(pixel_start(1):pixel_start(1)+sz,...
             pixel_start(2):column);
        p2 = image(pixel_start(1)+pixel_shifted(i):pixel_start(1)...
            +sz+pixel_shifted(i),pixel_start(2):column);
        part_corr_x(i) = corr2(p1,p2);
    end