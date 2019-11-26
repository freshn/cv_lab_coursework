function desc=DESC(frames,mag,angles)
nbp=4;
desc=zeros(1,nbp*nbp*8);
o=1;
s=1;
[M,N]=size(mag);
sigm0=3.2;
sbp=3*sigm0;
W=floor(sqrt(2)*sbp*(nbp+1)/2+0.5);
xp=fix(frames(1,1));
yp=fix(frames(2,1));
theta0=frames(3,1);
sin0=sin(theta0);
cos0=cos(theta0);
index=0;
histo=zeros(1,nbp*nbp*8);
for xs = max(xp-W,1):min(N-1,xp+W)
    for ys =  max(yp-W,1):min(M-1,yp+W)
        dx=xp-xs;
        dy=yp-ys;
        if dx^2+dy^2<W^2
            theta=angles(ys,xs);
            theta=mod((theta-theta0),2*pi);
            nx=(dy*cos0+dx*sin0)/sbp;
            ny=(-dy*sin0+dx*cos0)/sbp;
            nt=theta/pi*4;
            wsigma = nbp/2;
            mags=mag(ys,xs);
            wc=exp(-(nx*nx + ny*ny)/(2.0 * wsigma * wsigma));
            for cx=-1.5:1:1.5
                for cy=-1.5:1:1.5

                    if abs(nx-cx)<1&&abs(ny-cy)<1
                        ki=cx+2.5;
                        kj=cy+2.5;
                        ni1=ceil(nt);
                        ni2=floor(nt);
                        d=(1-abs(nx-cx))*(1-abs(ny-cy));
                        index=(((ki-1)*nbp+kj)-1)*8;
                        if ni1~=ni2

                            dt1=1-(ni1-nt);
                            dt2=1-(-ni2+nt);
                            index1=index+mod(ni1,8)+1;
                            index2=index+ni2+1;
                            histo(index1)=histo(index1)+wc*d*dt1*mags;
                            histo(index2)=histo(index2)+wc*d*dt2*mags;
                        else
                            histo(index+ni1)=histo(index+ni1)+wc*d*mags;
                        end
                    end
                end
            end
        end
    end
end
desc=histo;

desc = desc ./ norm(desc);
indx = desc > 0.2;
desc(indx) = 0.2;
desc = desc ./ norm(desc);
