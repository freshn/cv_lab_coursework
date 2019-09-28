y=sin([0:0.01:2*pi]); subplot(3,1,1), plot(y);
yd1=conv2(y,[-1,1],'valid'); subplot(3,1,2), plot(yd1);
yd2=conv2(y,[-1,2,-1],'valid'); subplot(3,1,3), plot(yd2);

print -dpng q411.png;