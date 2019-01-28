function [n,m,count]=imin(data)
[nn,mm]=find(data==0);

    for j=1:length(mm)
        data(nn(j),mm(j))=255;
    end
    
    count=min(min(data));
    [n,m]=find(data==count);