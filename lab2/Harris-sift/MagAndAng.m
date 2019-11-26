function [mag,ang]=MagAndAng(img)
%input:
% img:input image;
%output:
% mag: the magnitudes;
% ang: the angles;

%the fucniton is to calculate the magintudes and angles and save it in mag
%and ang;
%step 1:compute x and y derivates using pixel difference;
% %compute x and y derivates using pixel difference;
% diff_x = 0.5*(img(2:(end-1),3:(end))-img(2:(end-1),1:(end-2)));
% diff_y = 0.5*(img(3:(end),2:(end-1))-img(1:(end-2),2:(end-1)));
dx_filter = [-0.5 0 0.5];
dy_filter = dx_filter';
gradient_x = imfilter(img, dx_filter);
gradient_y = imfilter(img, dy_filter);
gradient_x=double(gradient_x);
gradient_y=double(gradient_y);
% %compute the magnitude of the gradient;
magnitudes=sqrt(gradient_x.^2+gradient_y.^2);


% %compute the orientation of the gradient;
% angles=atan2( gradient_x, gradient_y );
angles=mod(atan(gradient_y ./ (eps + gradient_x)) + 2*pi, 2*pi);
% angles(find(angles == pi)) = -pi;
% Store the magnitude of the gradient and the orientation of the gradient
% mag=magnitudes(2:end-1,2:end-1);
% ang=angles(2:end-1,2:end-1);
mag=magnitudes;
ang=angles;
end