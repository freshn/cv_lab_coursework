function frames=MajorOrientation(mag,ang,x,y)
% The next step of the algorithm is to assign orientations to the keypoints
% that have been located. ?This is done by looking for peaks in histograms of
% gradient orientations in regions surrounding each keypoint. ?A keypoint may be?
% assigned more than one orientation. ?If it is, then two identical descriptors?
% are added to the database with different orientations.

win_factor = 1.5 ; 
NBINS = 36;  
histo = zeros(1, NBINS); 
sigmaw = win_factor *6.4 ;
W = floor(3.0*sigmaw); 
[M, N] = size(mag); 

xp=round(x);
yp=round(y);
magnitudes=mag;
angles=ang;
for xs = max(xp-W,1):min(N-1,xp+W)
    for ys = max(yp-W,1):min(M-1,yp+W)
        dx = (xs - x);
        dy = (ys - y);
        if dx^2 + dy^2 <= W^2 
            wincoef = exp(-(dx^2 + dy^2)/(2*sigmaw^2));
            bin = round( NBINS * angles(ys, xs)/(2*pi) + 0.5); 
            histo(bin) = histo(bin) + wincoef * magnitudes(ys, xs); 
        end
    end
end
frames=[];
theta_max = max(histo);  
theta_indx = find(histo> 0.8 * theta_max); 
for i = 1: size(theta_indx, 2)
        theta = 2*pi * theta_indx(i) / NBINS;
        frames = [frames, [xp yp theta]']; 
end
end
