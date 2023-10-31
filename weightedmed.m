function result=weightedmed(depthBlock,weight)
% weightedmed is a function to realize weighted median filter
% parameter:
%     depthBlock : the local window of depth
%     weight : the weights of every pixels in local window
%     result : recovered local outcome
[m,n]=size(depthBlock);
hist=zeros(1,256);
Wsum=0;
for p=1:m
    for q=1:n
        hist(depthBlock(p,q)+1)=hist(depthBlock(p,q)+1)+weight(p,q);
        Wsum=Wsum+weight(p,q);
    end
end
HWsum=0;
for p=1:256
    HWsum=HWsum+hist(p);
    if(HWsum>=0.5*Wsum)
        result=p-1;
        break;
    end
end
    

