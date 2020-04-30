function [idata ] = morpho_ecg2( ecg,QRS ,fs )

for i=1:(length(QRS)-1)
    
 if QRS(1,i)>20 
     
[aa bb cc dd]= (findpeaks((ecg((QRS(1,i)-(0.07*fs)):(QRS(1,i)+(0.17*fs)))),'Annotate','extents','SortStr','descend'));


[aa1 bb1 cc1 dd1] = findpeaks((-ecg((QRS(1,i)-(0.07*fs)):(QRS(1,i)+(0.17*fs)))),'Annotate', 'extents', 'SortStr','descend');

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
   
    
ee = dd(1)/dd1(1);

ff = cc(1)/cc1(1);

gg = (dd(1).*cc(1))/(dd1(1).*cc1(1));

data(i,1:7) = [cc(1) dd(1) cc1(1) dd1(1) ee(1) ff(1) gg(1)];
 else
     
 end
 
end
data1 =  mean(data(:,:),1);
data2 = median(data(:,:),1);
data3 =  mode(data(:,:),1);
data4 = kurtosis(data(:,:),1);
data5 =  skewness(data(:,:),1);
data6 = std(data(:,:),1);
data7 = var(data(:,:),1);


idata=[data1 data2 data3 data4 data5 data6 data7];
    
end