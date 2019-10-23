function part_corr = part_corr(image, pixel_start, pixel_shifted, size)
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
       size = 70;
    end        
    for i = 1:1:length(pixel_shifted)
        p1 = image(pixel_start(1):pixel_start(1)+size,...
            pixel_start(2):pixel_start(2)+size);
        p2 = image(pixel_start(1)+pixel_shifted(i):pixel_start(1)...
            +size+pixel_shifted(i),pixel_start(2)+pixel_shifted(i):...
            pixel_start(2)+size+pixel_shifted(i));
        part_corr(i) = corr2(p1,p2);
    end
