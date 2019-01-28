function [n,m,count]=imax(data)
[nn,mm]=find(data==255);

    for j=1:length(mm)
        data(nn(j),mm(j))=0;
    end
    count=max(max(data));
    [n,m]=find(data==count);