% clear all;
% close all;
% clc
% %load groupinfo
% 
% data_dir = [pwd];
% 
% %% Add this directory to the MATLAB path.
% addpath(pwd)

% %% Load the list of records in the validation set.
% recordName= [ data_dir filesep 'RECORDS4'];
% 
% 
% fid = fopen(recordName,'r');
% if(fid ~= -1)
%     RECLIST = textscan(fid,'%s');
% else
%     error(['Could not open ' data_dir 'RECORDS for scoring. Exiting...'])
% end
% fclose(fid);
% RECORDS = RECLIST{1};
% 
% 
% 
% 
% %% Class determination Normal(N)/AF(A)/Others(O)/Noise(~)
% for i = 1:length(RECORDS)
%     fname = RECORDS{i};  
%     
%     ecg=load(fname);
%     % need to filter the ecg
%        signal=ecg.DD;
%        signal1=(signal-nanmean(signal))./nanstd(signal);
%        
%        % BandPass Filter
% d = designfilt('bandpassiir','FilterOrder',6, ...
%     'HalfPowerFrequency1',1,'HalfPowerFrequency2',35, ...
%     'SampleRate',300);
% 
% % Notch filter
% wo = 60/(300/2);  bw = wo/2;
% [b,a] = iirnotch(wo,bw);
%                     %y = filter(b,a,ecgn);
%                                 % plot(ecgn)
%                                 % hold on
%                                 % plot(y)
% 
%                                 % plot(abs(fft(x1)))
%                                 % hold on
%                                 % plot(abs(fft(y)))
%                                 % 
%                                 %fvtool(b,a);
% 
%     yy_1 = filter(b,a,signal1);
%     signal2=filtfilt(d,yy_1);
%        
%     
%     classifyResult(i) = challenge_test(signal2);
% 
%    
% end

clear all;
close all;
clc

filename= [pwd filesep 'RECORDS5'];

% 
% answers = dir(['answers.txt']);
% if(~isempty(answers))
%     while(1)
%         display(['Found previous answer sheet file in: ' pwd])
%         cont = upper(input('Delete it (Y/N/Q)?','s'));
%         if(strcmp(cont,'Y') || strcmp(cont,'N') || strcmp(cont,'Q'))
%             if(~strcmp(cont,'Y'))
%                 display('Exiting script!!')
%                 return;
%             end
%             break;
%         end
%     end
%     display('Removing previous answer sheet.')
%     delete(answers.name);
% end

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
for i = 255:length(RECORDS)
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
       
    
    classifyResult(i) = challenge_test(signal2);
    
    %classifyResult(i) = challenge([data_dir fname]);

    % write the answer to answers.txt file
    fprintf(fid,'%s,%s\n',RECORDS{i},classifyResult(i));

    total_time = total_time+toc;
    fprintf(['---Processed ' num2str(i) ' out of ' num2str(length(RECORDS)) ' records.\n'])
end