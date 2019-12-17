function [numA, numB] = count_lego(I)
  % This function counts blue 2*4 legos and red 2*2 legos. 
  % [Version: MATLAB R2019b]
  %
  % Paraments:
  %     OUTPUT:
  %         numA = the number of blue 2*4 lego.
  %         numB = the number of red 2*2 lego.
  %     INPUT:
  %         I1 = RGB image.
  %
  % Methods:
  %   At first, hsv information is used to select objects in certain color.
  %   Then, the function detects how many circles can be found in a single
  %   lego and determine if it is a target lego or not. In this step, two
  %   circle detection methods are combined to keep the stability and 
  %   efficiency. When determining legos, complex judging conditions are
  %   used in order to suit possible different situations (like several same
  %   color legos close to each other). For increasing speed and accuracy, 
  %   this function also considers if the outline of the detecting object 
  %   is convex or not. Finally, the number of blue 2*4 and red 2*2 legos
  %   can be counted.
  %
  % Procedures:
  %   Color segment based on HSV information --> Detect edge --> Count
  %   circles in each region and determine whether it is a target lego
  %   --> Count target legos
  %
  % Example:
  %   example.m 
  %
  % Reference:
  %   https://uk.mathworks.com/help/images/ref/regionprops.html
  %   https://uk.mathworks.com/help/images/detect-and-measure-circular-objects-in-an-image.html
 
    %% Color Segment
    % double image
    I = im2double(I);
    % detect blue objects
    I_b = detectB(I);
    % detect red objects
    I_r = detectR(I);
    % element-wise product to show certain color objects
    I_A = I.*I_b; 
    I_B = I.*I_r;
    % gray pictures for detect edge
    I_Ac = rgb2gray(I_A);
    I_Bc = rgb2gray(I_B);
    %% Detect Edge
    hsize = 18; sigma = 0.35;
    I_Ac = detectEdge(I_Ac, hsize, sigma);
    I_Bc = detectEdge(I_Bc, hsize, sigma);
    %% Count Lego
    [numA, selectedLegoA] = count(I_Ac, I_b, 3, 8);
    [numB, selectedLegoB] = count(I_Bc, I_r, 1, 4);
    disp(['The number of blue lego:' num2str(numA) '.'])
    disp(['The number of red lego:' num2str(numB) '.'])
%     %% Visualization
%     figure;set(gcf,'position',[50,0,1000,900]);
%     subplot(331),imagesc(I);title('Original image');
%     subplot(332),imagesc(I_A);title('Blue objects');colormap('gray');  
%     subplot(333),imagesc(I_B);title('Red objects');
%     subplot(334),imagesc(I_Ac);title('Blue objects edge');
%     subplot(335),imagesc(I_Bc);title('Red objects edge');
%     subplot(336),imagesc(selectedLegoA);title(['Selected blue legos:' num2str(numA)]);
%     subplot(337),imagesc(selectedLegoB);title(['Selected red legos:' num2str(numB)]);
end
%% Utilitization
function I_b = detectB(I)
    % blue hsv field
    h_min = 0.51; h_max = 0.62;
    s_min = 0.38; s_max = 1;
    v_min = 0; v_max = 1;
    I_hsv = rgb2hsv(I);
    I_s = (I_hsv(:,:,1) >= h_min) & (I_hsv(:,:,1) <= h_max);
    I_h = (I_hsv(:,:,2) >= s_min) & (I_hsv(:,:,2) <= s_max);
    I_v = (I_hsv(:,:,3) >= v_min) & (I_hsv(:,:,3) <= v_max);
    I_b = I_s & I_h & I_v;
    % remove noise
    I_b = imopen(I_b, strel('disk',2));
    I_b = imclose(I_b, strel('disk',9));
    I_b = bwareaopen(I_b, 4500);
end
function I_r = detectR(I)
    % red hsv field
    h_min = 0.94; h_max = 0.017;
    s_min = 0.5; s_max = 1;
    v_min = 0; v_max = 1;
    I_hsv = rgb2hsv(I);
    I_s = (I_hsv(:,:,1) >= h_min) | (I_hsv(:,:,1) <= h_max);
    I_h = (I_hsv(:,:,2) >= s_min) & (I_hsv(:,:,2) <= s_max);
    I_v = (I_hsv(:,:,3) >= v_min) & (I_hsv(:,:,3) <= v_max);
    I_r = I_s & I_h & I_v;
    % remove noise
    I_r = imopen(I_r, strel('disk',2));
    I_r = imclose(I_r, strel('disk',9));
    I_r = bwareaopen(I_r, 4500);
end

function I = detectEdge(I, hsize, sigma)
    % detect edge using log mask
    mask = fspecial('log', hsize, sigma);
    I = imfilter(I, fspecial('gaussian'));
    I = imfilter(I, mask);
    I = I < 0;
    % remove holes, compelete circles
    I = imopen(I, strel('disk',2));
    I = imclose(I, strel('disk',2));
    I = ~bwareaopen(~I, 300);
    % remove bridges, complete circles
    I = imdilate(I, strel('disk',2));
    I = imerode(I, strel('diamond', 2));
    I = bwareaopen(I, 200);
    % smooth
    I = ~bwmorph(~I, 'majority', 5);
end
function [num, cs] = CircularityCountCircles(I, threshold)
    [b, L] = bwboundaries(I);
    s = regionprops(L, 'Circularity');
    num = 0;
    Ifill = imfill(I, 'holes');
    if nargout > 1
        cs = isconvex(Ifill);
    end
    for i = 1:length(b)
        if abs(s(i).Circularity-1) <= threshold
            num = num + 1;
        end
    end    
end
function c = houghCountCircles(I, r_range, sense)
    [c_hough, r, m] = imfindcircles(I, r_range, 'Sensitivity', sense, 'Method', 'TwoStage');
    c = size(c_hough, 1);
    % using several strong circles when the number of detected circles is
    % too big
    while c >= 16
        c_hough = c_hough(m>mean(m));
        r = r(m>mean(m));
        m = m(m>mean(m));
        c = size(c_hough, 1);
    end
end
function convex_level = isconvex(I)
    [L,~] = bwlabel(I);
    stats = regionprops(L,'Area','ConvexArea');
    area = stats.Area;
    convex = stats.ConvexArea;
    extraconvex = convex-area;
    convex_level = extraconvex./area;
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
       %% count circles by hough transform
        r_range = [12 35]; sense = 0.9;
        c_h = houghCountCircles(R, r_range, sense);
        c_h_ = houghCountCircles(~R, r_range, sense);
        % smooth 
        while c_h_ - c_h > max
            c_h_ = c_h_- 1;
            c_h = c_h + 1;
        end    
       %% count circles by circularity 
        a = 0.15;
        [cp, cs1] = CircularityCountCircles(R, 0.15);
        cn = CircularityCountCircles(~R, 0.15);
        % smooth
        c = round(a*cn+(1-a)*cp);
        cslimit = 0.5;
       %% red lego detect
        if max == 4 
            % only one lego
            if ((c==min||c==max)&&c_h<=max+1&&c_h_<=max+1)&& cs1<cslimit ...
                    || ((c_h>=min && c_h<=max && c_h~=min+2)&&(c_h_>=min && c_h_<=max && c_h_~=min+2))
                num = num + 1;
                selectedLego = xor(selectedLego,R);
            end    
       %% blue lego dettect
        elseif max == 8  
            % two or more target legos close to each other
            if (c>=max+min) || ((c>=max-1)&&((c_h+c_h_)>=2*(max+min))&&...
                    (c_h>=max+min||c_h_>=max+min)) && (c_h>=min&&c_h_>=min)
                num = num + 2;
                selectedLego = xor(selectedLego,R);    
                continue
            end
            % one target lego close to another lego
            if (c==min||c==max||c==max-1) || ((c>=min-1&&c<=max+1)&&...
                    ((c_h>=min&&c_h<=max&&c_h~=min+1)||...
                    (c_h_>=min&&c_h_<=max&&c_h_~=min+1)))
                num = num + 1;
                selectedLego = xor(selectedLego,R);
                continue
            end    
            % only one lego
            if (c>max&&c<=max+min)&&(c_h>=max+min||c_h_>=max+min)&&(c_h<min||c_h_<min)&&cs1<cslimit 
                num = num + 1;
                selectedLego = xor(selectedLego,R);   
            end    
        end    
    end
end