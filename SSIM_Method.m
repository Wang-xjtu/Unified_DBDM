function result=SSIM_Method(color,depth,Rrecover)
% SSIM_Method is a function to recover depth
% parameters:
%     color : input RGB image
%     depth : input depth map
%     Rcanny : the radius for expanding edges of depth map
%     Rrecover : the radius of local window for weighted median filter
%     result: reovered depth map
%% parameters setting

% standard deviation of Gaussian kernel
sigmaC=10;
sigmaCn=7;
sigmaD=10;
Rcanny=3;

rCalculate=ceil(1.5*Rcanny); % radius of local window for SSIM
threshold=0.5; % threshold for binarization
%% LUT calculating
colorrange=0:3*(255+10)^2;
colorweightLUT=exp(-colorrange/(3*2*sigmaC^2));
colorweightRLUT=exp(-colorrange/(3*2*sigmaCn^2));

depthrange=0:(255+10)^2;
depthweightLUT=exp(-depthrange/(2*sigmaD^2));

clear colorrange;
clear depthrange;
%% preprocessing

[m,n,l]=size(depth);

% Rrecover=ceil(sqrt(m*n/180)/2);
pixels_threshold=m*n*0.001;

if l>1
    depth=rgb2gray(depth);
end
color=double(color);
depth=double(depth);

WBinc=zeros(m,n);

%% start ssim method
for i=1:100
    
    depth=guidedfilter(depth/255,depth/255,2,0.1^2,WBinc)*255;
    
    % obtain edges of depth map
    BW=edge(depth,'canny',[0.01,0.02]);
    BWzD=double(BW);
    BWzD(BWzD==1)=255;% set 1 to 255 for display
    
    % expand edges as areas 
    Border=ordfilt2(double(BWzD),Rcanny*Rcanny,ones(Rcanny,Rcanny));
    
    Wbefore=WBinc;
    
    % detect structural distortion in the areas
    Winc=det_distortion(color,depth,rCalculate,colorweightLUT,depthweightLUT,Border);
    
    % Winc = 0 or 1
    WBinc=Winc;
    WBinc(WBinc<threshold)=0;
    WBinc(WBinc>=threshold)=1;
    
    % terminal condition
    difference=sum(sum(abs(Wbefore-WBinc)));
    if difference<=pixels_threshold
        depth=recover(depth,color,WBinc,colorweightRLUT,Rrecover);
        break;
    end
    
    % distorted areas recovery
    depth=recover(depth,color,WBinc,colorweightRLUT,Rrecover);
   
    disp(['----------------------- iteration:',num2str(i)]);
 
end
result=medfilt2(depth);
result(:,1)=depth(:,1);
result(:,n)=depth(:,n);
result(1,:)=depth(1,:);
result(m,:)=depth(m,:);
end