function [numA, numB] = count_lego(I)
    I = im2double(I);
    I_b = detectB(I);
    I_r = detectR(I);
    I_A = I.*I_b; 
    I_B = I.*I_r;
    I_Ac = rgb2gray(I_A);
    I_Bc = rgb2gray(I_B);
    hsize = 18; sigma = 0.35;
    I_Ac = detectEdge(I_Ac, hsize, sigma);
    I_Bc = detectEdge(I_Bc, hsize, sigma);
    
    [numA, selectedLegoA] = count(I_Ac, I_b, 3, 8);
    [numB, selectedLegoB] = count(I_Bc, I_r, 1, 4);
    
    figure;set(gcf,'position',[50,0,1000,900]);
    subplot(331),imagesc(I);title('Original image');
    subplot(332),imagesc(I_A);title('Blue objects');colormap('gray');  
    subplot(333),imagesc(I_B);title('Red objects');
    subplot(334),imagesc(I_Ac);title('Blue objects edge');
    subplot(335),imagesc(I_Bc);title('Red objects edge');
    subplot(336),imagesc(selectedLegoA);title(['Selected blue legos:' num2str(numA)]);
    subplot(337),imagesc(selectedLegoB);title(['Selected red legos:' num2str(numB)]);
end

function I_r = detectR(I)
    h_min = 0.94; h_max = 0.017;
    s_min = 0.5; s_max = 1;
    v_min = 0; v_max = 1;
    I_hsv = rgb2hsv(I);
    I_s = (I_hsv(:,:,1) >= h_min) | (I_hsv(:,:,1) <= h_max);
    I_h = (I_hsv(:,:,2) >= s_min) & (I_hsv(:,:,2) <= s_max);
    I_v = (I_hsv(:,:,3) >= v_min) & (I_hsv(:,:,3) <= v_max);
    I_r = I_s & I_h & I_v ;
    I_r = imopen(I_r, strel('disk',2));
    I_r = imclose(I_r, strel('disk',9));
    I_r = bwareaopen(I_r, 4500);
    %I_r = imfill(I_r, 'holes');
end
function I_b = detectB(I)
    h_min = 0.51; h_max = 0.62;
    s_min = 0.38; s_max = 1;
    v_min = 0; v_max = 1;
    I_hsv = rgb2hsv(I);
    I_s = (I_hsv(:,:,1) >= h_min) & (I_hsv(:,:,1) <= h_max);
    I_h = (I_hsv(:,:,2) >= s_min) & (I_hsv(:,:,2) <= s_max);
    I_v = (I_hsv(:,:,3) >= v_min) & (I_hsv(:,:,3) <= v_max);
    I_b = I_s & I_h & I_v ;
    I_b = imopen(I_b, strel('disk',2));
    I_b = imclose(I_b, strel('disk',9));
    I_b = bwareaopen(I_b, 4500);
    %I_b = imfill(I_b, 'holes');
end
function I = detectEdge(I, hsize, sigma)
    mask = fspecial('log', hsize, sigma);
    I = imfilter(I, fspecial('gaussian'));
    I = imfilter(I, mask);
    I = I < 0;
    I = imopen(I, strel('disk',2));
    I = imclose(I, strel('disk',2));
    I = ~bwareaopen(~I, 300);
    
    I = imdilate(I, strel('disk',2));
    I = imerode(I, strel('diamond', 2));
    I = bwareaopen(I, 200);
    I = ~bwmorph(~I, 'majority', 5);
end
function num = CircularityCountCircles(I, threshold)
    [b, L] = bwboundaries(I);
    s = regionprops(L, 'Circularity');
    num = 0;
    for i = 1:length(b)
        if abs(s(i).Circularity-1) <= threshold
            num = num + 1;
        end
    end    
end
function [num, selectedLego] = count(I, mask, min, max)
    [lm, index] = bwlabel(mask);
    % keeping search region big enough 
    lm = imfill(lm, 'holes');
    lm = imdilate(lm, strel('disk',10));
    num = 0;
    selectedLego = zeros(size(I));
    for i = 1:index
        R = I .* (lm == i);
        % count circles by hough transform
        if max == 8
            sense = 0.9;
        else
            sense = 0.85;
        end    
        r_range = [12 35];
        c_h = houghCountCircles(R, r_range, sense);
        c_h_ = houghCountCircles(~R, r_range, sense);
        while c_h_ - c_h > max
            c_h_ = c_h_- 1;
            c_h = c_h + 1;
        end    
        % count circles by circularity 
        a = 0.15;
        cp = CircularityCountCircles(R, 0.15);
        cn = CircularityCountCircles(~R, 0.15);
        c = round(a*cn+(1-a)*cp);
        if max == 4
            if (c>=min && c<=max && c~=min+2 && c~=min+1) ...
                    || ((c_h>=min && c_h<=max && c_h~=min+2)&&(c_h_>=min && c_h_<=max && c_h_~=min+2))
                num = num + 1;
                selectedLego = xor(selectedLego,R);
            end    
        else    
            if (c>=max+min) || ((c>=max-1)&&((c_h+c_h_)>=2*(max+min))&&...
                    (c_h>=max+min||c_h_>=max+min)) && (c_h>=min&&c_h_>=min)
                num = num + 2;
                selectedLego = xor(selectedLego,R);    
                continue
            end
            if (c==min||c==max||c==max-1) || ((c>=min-1&&c<=max+1)&&...
                    ((c_h>=min&&c_h<=max&&c_h~=min+1)||...
                    (c_h_>=min&&c_h_<=max&&c_h_~=min+1)))
                num = num + 1;
                selectedLego = xor(selectedLego,R);
                continue
            end    
            if (c>max&&c<=max+min)&&(c_h>=max+min||c_h_>=max+min)&&(c_h<min||c_h_<min) 
                num = num + 1;
                selectedLego = xor(selectedLego,R);   
            end
        end    
    end
end
function c = houghCountCircles(I, r_range, sense)
    [c_hough, r, m] = imfindcircles(I, r_range, 'Sensitivity', sense, 'Method', 'TwoStage');
    c = size(c_hough, 1);
    while c > 16
        c_hough = c_hough(m>mean(m));
        r = r(m>mean(m));
        m = m(m>mean(m));
        c = size(c_hough, 1);
    end
end