clear;
clc;

r=20; % we suggest 20 for common RGB-D data, 5 for data with slightly distortions, 30 for data with very serious distortions.
%% test: 16X upsampling with noise
example='Sword1';

rgb_path=strcat('test_imgs/rgb/', example, '.png');
depth_path=strcat('test_imgs/depth/', example, '_16X.png');
save_path=strcat('test_imgs/result/',example,'_16X_',int2str(r),'.png');

img=imread(rgb_path);
depth=imread(depth_path);
[~,~,l]=size(depth);
if l>1
    depth=rgb2gray(depth);
end
% main function of the proposed method
disp("------started------");
result=SSIM_Method(img,depth, r);
imwrite(uint8(result),save_path);
disp("------finished------");