function result=recover(depth,color,WBinc,colorweightRLUT,Rrecover)
% recover is a function to recover depth pixels where are regared as structural
% distortion areas
% parameter:
%     depth: a input depth map
%     color: a input RGB image
%     WBinc: the mask to display where are distorted areas
%     colorweightRLUT: LUT for fast calculation of RGB
%     Rrecover: the radius of local window for weighted median filter
%     result: the recovered depth map of current iteration
[m,n]=size(depth);
result = zeros(m,n);
for p = 1 : m
    for q = 1 : n
        
        if(WBinc(p,q)==0)
            startm = p-Rrecover;
            startn = q-Rrecover;
            endm = p+Rrecover;
            endn = q+Rrecover;
            
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
            ColorWeight = double(zeros(endm-startm+1,endn-startn+1));
            for kk =startm:endm
                for ll = startn:endn
                    diffR = color(kk,ll,1)- color(p,q,1);
                    diffG = color(kk,ll,2)- color(p,q,2);
                    diffB = color(kk,ll,3)- color(p,q,3);
                    ColorWeight(kk-startm+1,ll-startn+1)= colorweightRLUT(int32(round(diffR*diffR+diffG*diffG+diffB*diffB))+1);
                end
            end
            % calculate recovered weights
            ColorWeight = ColorWeight.*WBinc(startm:endm,startn:endn);
            WeightSum = sum(sum(ColorWeight));
            ColorWeight=ColorWeight/WeightSum;
            
            if(WeightSum<=0.05)
                result(p,q)=depth(p,q);
            else
                result(p,q)=weightedmed(uint8(depth(startm:endm,startn:endn)),ColorWeight);
                
            end
            
        else
            result(p,q)=depth(p,q);
            
        end
    end
end
end

