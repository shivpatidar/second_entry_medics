function [data ] = morpho_ecg3( ecg,QRS ,fs)

for i=1:(length(QRS)-1)
    
    if QRS(1,i)>20
        
        [aa bb cc dd]= (findpeaks((ecg((QRS(1,i)-(0.07*fs)):(QRS(1,i)+(0.17*fs)))),'Annotate','extents','SortStr','descend'));
        
        
        [aa1 bb1 cc1 dd1] = findpeaks((-ecg((QRS(1,i)-(0.07*fs)):(QRS(1,i)+(0.17*fs)))),'Annotate', 'extents', 'SortStr','descend');
        
        if isempty(aa==1)
            aa=1;
        else
        end
        if isempty(aa1==1)
            aa1=1;
        else
        end
        
        if isempty(bb==1)
            bb=1;
        else
        end
        if isempty(bb1==1)
            bb1=1;
        else
        end
        
        if isempty(cc==1)
            cc=1;
        else
        end
        
        if  isempty(cc1==1)
            cc1=1;
        else
        end
        if    isempty(dd==1)
            dd=1;
        else
        end
        
        if   isempty(dd1==1)
            dd1=1;
        else
        end
        
        
        
        
        idata(i,1:6) = [(aa(1)-aa1(1)) (bb(1)-bb1(1)) (cc(1)-cc1(1)) (dd(1)-dd1(1)) aa(1)/aa1(1)...
            bb(1)/bb1(1) ];
    else
        
    end
    
end
data1 =  mean(idata(:,:),1);
data2 = median(idata(:,:),1);
data3 =  mode(idata(:,:),1);
data4 = kurtosis(idata(:,:),1);
data5 =  skewness(idata(:,:),1);
data6 = std(idata(:,:),1);
data7 = var(idata(:,:),1);


data=[data1 data2 data3 data4 data5 data6 data7];
    
end