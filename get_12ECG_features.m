function [fb_v1, fb_lead1, st_lead1, avb_feat, lbbb_feat, normalstd_feat] = get_12ECG_features(data, header_data)

       % addfunction path needed
        addpath(genpath('Tools/'))
        %load('HRVparams_12ECG','HRVparams')
%         load('dist_final_temp','template')
%         load('data_sig','data_sig')
	% read number of leads, sample frequency and gain from the header.	

	[recording,Total_time,num_leads,Fs,gain,age,sex]=extract_data_from_header(header_data);

    fb_v1=get_fbfeat(data,7,Fs);
    fb_lead1=get_fbfeat(data,1,Fs);
    pr_feat=get_prfeat(data,1);
    st_lead1=ststats(data,Fs,1);
    st_avr=ststats(data,Fs,4);
   avb_feat=[fb_lead1 pr_feat st_lead1];
   lbbb_feat=[fb_lead1 st_lead1];
   normalstd_feat=[fb_lead1 st_avr st_lead1];
   
    
  
end

function [feat] = get_fbfeat(data,lead,fs)
fs=500;
        if size(data,2)<5000
            ecg11 = [data(lead,:) data(lead,:)];
            ecg22=ecg11(:,1:5000);
        else
        ecg22=data(lead,1:5000);    
        end
        ecg=BP_filter_ECG(ecg22,fs);
        feat=feat_29_2020(ecg,fs);
end

function [feat] = get_prfeat(data,lead)
fs=500;
samp_len=250;
PR_seg=[];
piks=[];
PR_idx=[];
P_idx=[];
PR_interval=[];

ecg=data(lead,:);
ecg=BP_filter_ECG(ecg,500);
[QRS,sign,en_thres] = qrs_detect2(ecg',0.25,0.6,fs);%Detecting QRS ( Note: Included as it is from the sample file)
for i=1:1:size(QRS,2)-3
    PR_seg=ecg(1,(QRS(1,i+1)-(0.25*fs)):QRS(1,i+1));
    piks=findpeaks(PR_seg);
    m=max(piks);
    if isempty(m)
      PR_interval(i,1)=60;  
    else
    PR_idx=find(PR_seg==m);
    P_idx=(QRS(1,i+1)-(0.25*fs))+PR_idx(1,1);
    PR_interval(i,1)=QRS(1,i+1)-P_idx;
    end
end
    pr=rmoutliers(PR_interval,'percentile',[20 100]);
    if isempty(pr)
        feat=[60 4 20 60 1 8];
    else
        
    feat=[mean(pr) var(pr) std(pr) median(pr) skewness(pr) kurtosis(pr)];
   
    end
end


function [filt_signal1] = BP_filter_ECG(ecg,fs)

ecg=ecg;
fs=fs;

d = designfilt('bandpassiir','FilterOrder',6, ...
    'HalfPowerFrequency1',1,'HalfPowerFrequency2',35, ...
    'SampleRate',fs);
%% Filtering 
    filt_signal1=filtfilt(d,ecg);
   
end

function [feat] = ststats(data,fs,lead)
signal=data(lead,:);
try
[y,~,~] = qrs_detect2(signal',0.25,0.6,fs);
    for i=1:length(y)
        try
    x{i}=signal(y(i):y(i)+80);%x:st segments
        catch
            x{i}=(signal(y(i):length(signal)));
        end
        
    st_median(i,:) = median(x{i});
    st_kurto(i,:) = kurtosis(x{i});
    st_skew(i,:) = skewness(x{i});
    st_mean(i,:) = mean(x{i});
    st_mode(i,:) = mode(x{i});
    st_max(i,:)=max(x{i});
    st_min(i,:)=min(x{i});
    st_var(i,:)=var(x{i});
    energy(i,:)=sum(x{i}.^2);
    e1(i,:)=wentropy(x{i},'norm',4);
    e2(i,:)=wentropy(x{i},'sure',0.06);
    e3(i,:)=wentropy(x{i},'norm',3);
    
    end
   
    feat=mean([e1 e2 e3 energy st_var st_median, st_kurto, st_skew, st_mean, st_mode,st_max, st_min ]); 
    if size(feat,2)<12
        feat=[1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000];
    end
catch
    feat=[1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000];
end
 
end
