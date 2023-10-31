function result=det_distortion(color,depth,r,colorweightLUT,depthweightLUT,Border)
% det_distortion is a function to detect structual distortion of depth map
% parameters:
%     color : input RGB image
%     depth : input depth map
%     r : the radius of local window
%     colorweightLUT: LUT of RGB for fast calculation
%     depthweightLUT: LUT of depth for fast calculation
%     Border : the expanded areas around edges of depth map
%     result : structural distortion area depth in Border 

[m,n]=size(depth);
result=ones(m,n);
for p=1:m
    for q=1:n
        if(Border(p,q)==255)
            startm=p-r;
            startn=q-r;
            endm=p+r;
            endn=q+r;
            if(startm<1)
                startm = 1;
            end
            if(startn<1)
                startn = 1;
            end
            if(endm>m)
                endm = m;
            end
            if(endn>n)
                endn = n;
            end
            % RGB and depth Gaussian matrix calculation
            colorweight=double(zeros(endm-startm+1,endn-startn+1));
            depthweight=double(zeros(endm-startm+1,endn-startn+1));
            for kk =startm:endm
                for ll = startn:endn
                    diffR = color(kk,ll,1)- color(p,q,1);
                    diffG = color(kk,ll,2)- color(p,q,2);
                    diffB = color(kk,ll,3)- color(p,q,3);
                    diff=depth(kk,ll)-depth(p,q);
                    
                    colorweight(kk-startm+1,ll-startn+1)= colorweightLUT(int32(round(diffR*diffR+diffG*diffG+diffB*diffB))+1);
                    depthweight(kk-startm+1,ll-startn+1)=depthweightLUT(int32(round(diff*diff))+1);
                    
                end
            end
            SSIM=SSIM_Block(colorweight,depthweight);
            result(p,q)=SSIM;
        end
    end
end