function [data] = New_challenge(ecg)
%
% Sample entry for the 2017 PhysioNet/CinC Challenge.
%
% INPUTS:
% recordName: string specifying the record name to process
%
% OUTPUTS:
% classifyResult: integer value where
%                     N = normal rhythm
%                     A = AF
%                     O = other rhythm
%                     ~ = noisy recording (poor signal quality)
%
% To run your entry on the entire training set in a format that is
% compatible with PhysioNet's scoring enviroment, run the script
% generateValidationSet.m
%
% The challenge function requires that you have downloaded the challenge
% data 'training_set' in a subdirectory of the current directory.
%    http://physionet.org/physiobank/database/challenge/2017/
%
% This dataset is used by the generateValidationSet.m script to create
% the annotations on your training set that will be used to verify that
% your entry works properly in the PhysioNet testing environment.
%
%
% Version 1.0
%
%
% Written by: Shivnarayan Patidar and Ashish Sharma April 2017
%             shivnarayan.patidar@nitgoa.ac.in
%
% Last modified by:


%% Class determination Normal(N)/AF(A)/Others(O)/Noise(~)


fs=300;

%ecg=(ecg-nanmean(ecg))./nanstd(ecg);
[QRS,sign,en_thres] = qrs_detect2(ecg',0.25,0.6,fs); 
%Detecting QRS ( Note: Included as it is from the sample file)


% if length(QRS)<6
%     
%     SHEe=ShE(ecg);%shanon entropy%---------
%     TKurtoecg=kurtosis(Teager(ecg));
%     datafe=[TKurtoecg log(abs(SHEe))];
%     [MD1, re_PE1] = rePE(ecg, 1, 2, 3, 0.01, 0.045);
%     datarepe=[sum(MD1./length(ecg)) ];
%     data=[ datarepe datafe ];
%    
% label = predict(Mdl1,data);%bag of tree based decision
% switch label
%     case 1
%         classifyResult ='N';
%     case 2
%        classifyResult ='A';
%     case 3
%        classifyResult ='O';
%     otherwise
%         classifyResult ='~';
% end
% 
% else
    RR=diff(QRS')/fs;
    if length(RR)<21
        RR=[RR' RR' RR']';
    else
    end
    HR=(1./RR).*60;
    %--------Computing Fourier Bessels of RR and HR interval and respective features--------------
    [ a3hr ] = fourierbessel(HR' );
    [ a3rr ] = fourierbessel(RR' );
    [xfrr,frr] = fft_freq(a3rr,1,[],320);
    % ------------------Direct features-------
    %ecg1=ecg(750:end);
    ecg1=ecg;
    SPEe=SpE(ecg1);%spectral entropy
    SHEe=ShE(ecg1);%shanon entropy%---------
    %--------Teager energy----
    TeagerHR=sum(Teager(HR).^2);
    TKurtoHR=kurtosis(Teager(HR));
    TKurtoecg=kurtosis(Teager(ecg1));
    TSkewa3hr=skewness(Teager(a3hr));
    TStda3hr=std(Teager(a3hr));
    TStdHR=std(Teager(HR));
    %--------Sample entropies----
    SnpHR=sampen(HR,[],0.1,[],0,[]);
    SnpRR=sampen(RR,2,0.1,[],0,[]);
    Snpfrr=sampen(abs(xfrr),2,0.1,[],0,[]);
    
    %-------------Other recent features--------
    SPE=SpE(HR);%Based on HR
    Mode=mode(a3hr);
    
    if (SnpHR(2,1)==Inf)
        SnpHR(2,1)=1;
    else
    end
    
    datafe=[SnpHR(1,1)' SnpRR(2,1)'  Snpfrr(1,1)' ...
        TeagerHR, TKurtoHR,TKurtoecg,TSkewa3hr,TStda3hr,TStdHR,...
        SPE, log(abs(Mode)), log(abs(SPEe)),log(abs(SHEe))];
    %-------other entropies-------------
    
    e1=wentropy(RR,'log energy');
    e4=wentropy(RR,'norm',9);
    e8=wentropy(a3rr,'norm',4);
    e9=wentropy(Teager(RR),'log energy');
    e11=wentropy(Teager(RR),'sure',0.06);
    e12=wentropy(Teager(RR),'norm',3);
    
    datawen=[e1 e4 e8 e9  e11 e12 ];
    
    %------rePE-based---features-----------
    [MD1, re_PE1] = rePE(ecg1, 1, 2, 3, 0.01, 0.045);
    [MD2, re_PE2] = rePE(RR, 1, 2, 3, 0.01, 0.82);
    [MD4, re_PE4] = rePE(a3hr, 2, 3, 8, 1,141);
    
    datarepe=[sum(MD1./length(ecg1)) sum(re_PE2.^2) sum(MD2./length(RR))...
        sum(re_PE4.^2) sum(MD4./length(a3hr))];
    
    
    %------------------statistics of RR and HR--------
    
    RR_mean = mean(RR);
    RR_median = median(RR);
    RR_mode = mode(RR);
    RR_Kurto = kurtosis(RR);
    RR_skew = skewness(RR);
    
    
    HR_mean = mean(HR);
    HR_median = median(HR);
    HR_mode = mode(HR);
    HR_Kurto = kurtosis(HR);
    HR_skew = skewness(HR);
    HR_Std = std(HR);
    HR_Var = var(HR);
    
    mecg=mean(ecg1);
    
    datastat = [ RR_mean./mecg RR_median RR_mode RR_Kurto RR_skew HR_mean HR_median HR_mode HR_Kurto./mecg HR_skew  HR_Std./mecg HR_Var./mecg];
    data1=[datawen datarepe datafe  datastat];
    %---segmentation based morphological features
    
    
    [ segs ] = segment_ecg_RtoR( ecg,QRS,fs );
    data21 = morphoroughness(segs );
    data2=[data21(1)./mecg data21(2:4)];
    
    datai= [data1 data2 ];
    datam= morpho_ecg2( ecg,QRS );
    
    datam2= morpho_ecg3( ecg,QRS );

           Snpecg=sampen(ecg(750:end),30,0.1,[],0,[]); 
     data5=Snpecg';

       data6=peaksinfo_ecg(ecg',QRS,fs );

    covtype1=[datai(1,[3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,26,27,28,29,30,31,32,39,36,38,40])    ];
    dataa=[ covtype1 data5(1,[28 30]) datam(1,[ 6  15  17  36 37 43 46   ]) datam2(1,[1 3 7 20]) data6];
   
    for i2=1:47
        if (isnan(dataa(i2))== 1)
            dataa(i2)=0;            
        else
        end
        
        if (dataa(i2)==Inf)
            dataa(i2)=1;
            
        else
        end
    end
        
    
    
    
data= dataa;
end
    
