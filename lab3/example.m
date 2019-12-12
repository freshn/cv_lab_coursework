clc,clear;
for i = 6
    if i <= 9
        I = imread(['img/train0', num2str(i), '.jpg']);
    else
        I = imread(['img/train', num2str(i), '.jpg']);
    end    
    [n1, n2] = count_lego(I);
end
