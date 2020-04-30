clear all;
close all;
clc

filename= [pwd filesep 'RECORDS5'];

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
for i = 1:length(RECORDS)
    fname = RECORDS{i};
    tic;        
    ecg=load(fname);
    
    % need to filter the ecg
       signal=ecg.DD;
         if i<80
       signal1=signal*4;
      
         else
       signal1=signal*1000000;
        signal1=signal1(1:9000);
         end
       %signal1=(signal-nanmean(signal))./nanstd(signal);
       
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
       
    data(i,1:9000)=signal2;
    
    
end


