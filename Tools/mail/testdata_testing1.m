
clear all;
close all;
clc

filename= [pwd filesep 'RECORDS6'];

% RECORDS6 and RECORDS5
% for general we use RECORDS5 as we have used in commparative annotation calculation.
% However, RECORDS6 is used with the change in NAK50210 with NAK50206

%% Load the list of records in the validation set.
fid = fopen(filename);
if(fid ~= -1)
    RECLIST = textscan(fid,'%s');
else
    error(['Could not open ' data_dir 'RECORDS for scoring. Exiting...'])
end
fclose(fid);
RECORDS = RECLIST{1};



%% Running on the validation set and obtain the score results
classifyResult = zeros(length(RECORDS),1);
total_time     = 0;

fid=fopen('answers.txt','wt');
filt_signal1={};

for i = 1:length(RECORDS)
    fname = RECORDS{i};
    tic;        
    ecg=load(fname);
    
    % need to filter the ecg
       signal=ecg.DD;
       signal1=(signal-nanmean(signal))./nanstd(signal);
       
       % BandPass Filter
d = designfilt('bandpassiir','FilterOrder',6, ...
    'HalfPowerFrequency1',1,'HalfPowerFrequency2',35, ...
    'SampleRate',300);

% Notch filter
wo = 60/(300/2);  bw = wo/2;
[b,a] = iirnotch(wo,bw);
                    %y = filter(b,a,ecgn);
                                % plot(ecgn)
                                % hold on
                                % plot(y)

                                % plot(abs(fft(x1)))
                                % hold on
                                % plot(abs(fft(y)))
                                % 
                                %fvtool(b,a);

    yy_1 = filter(b,a,signal1);
    signal2=filtfilt(d,yy_1);
    filt_signal1{i,1}=signal2; 
    
end

%% Normalization
norm_signal = cellfun(@(x) ((x-mean(x))./(std(x))) ,filt_signal1,'UniformOutput',false);

[Data22, mm, md] = cellfun(@(x)Norm_maxmin2(x),norm_signal, 'UniformOutput',false);

QRS_value1 = cellfun(@(x)qrs_detect2((x)',0.25,0.5,300)',Data22,'UniformOutput',false);


%% RR interval
RR_int1 = cellfun(@(x)diff(x')/300,QRS_value1,'UniformOutput',false);

%% FB coeff.
FBCC1=cellfun(@(x)fourierbessel(x),RR_int1,'UniformOutput',false);
FBCC1_1 = cellfun(@(x)interp1(x,0:(length(x)/110):(length(x))),FBCC1','UniformOutput',false);
FBCC1_2=cellfun(@(x)[x(12:end)],FBCC1_1,'UniformOutput',false);
%FBCC=FBCC1_2;
%% Finding the NaN value 
 XV_1 = [FBCC1_2{:}];
  XV_1(isnan(XV_1))=0;
for i=1:(length(XV_1)/300)
  a=300*(i-1)+1;
  b=300*i;
  FBCC1_3{i} = XV_1(:,a:b);
end
 
%  FB (feature normaliztion ) Normalization 
            %mu=-0.0128; sg=0.2824; -0.0129 and 0.2752;
            % calculate the mean and std
            XV = [FBCC1_3{:}];
            mu = mean(XV,2);
            sg = std(XV,[],2);
                      
XSD1 = cellfun(@(x)(x-mu)./sg, FBCC1_3,'UniformOutput',false);

%XSD22 = cellfun(@(x)(x-mu)./sg, FBCC1_3,'UniformOutput',false);

Norm_sig = cellfun(@(x, y)(x-mean(x)./y ), Data22, md, 'UniformOutput',false);

Data_seg = cellfun(@(x,y,z)segments_generator(x,y,z), Norm_sig, mm, md, 'UniformOutput',false);

Data_seg1 = cellfun(@(x)[10*x], Data_seg, 'UniformOutput',false);

    
    
    
   
    
    
    
    
    
    
end