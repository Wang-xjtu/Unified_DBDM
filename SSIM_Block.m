function SSIM=SSIM_Block(Block1,Block2)
% SSIM_Block is a function to calculate SSIM between Gaussian matrix of RGB
% and depth
% parameters:
%     Block: RGB or depth block in corresponding location
%     SSIM : the ssim index between two Gaussian matrix of RGB and depth

k=[0.01,0.03];
L=1; % Gaussian kernel range from 0 to 1
C=(k.*L).^2;
E=[mean2(Block1),mean2(Block2)];
V=[var(Block1(:)),var(Block2(:))];

[m,n]=size(Block1);
temp=0;
for i=1:m
    for j=1:n
        temp=temp+(Block1(i,j)-E(1))*(Block2(i,j)-E(2));
    end
end
VXY=temp/(m*n-1); % covariance

SSIM=((2*E(1)*E(2)+C(1))*(2*VXY+C(2)))/((E(1)^2+E(2)^2+C(1))*(V(1)+V(2)+C(2)));
if SSIM < 0
    SSIM=0;
end
end