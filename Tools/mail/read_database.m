clear all
data_dir= [pwd filesep 'AF Termination' filesep];

%DATAFILE='a01.dat';        
recordName= [ data_dir filesep 'RECORDS'];
fid = fopen(recordName, 'r');
if(fid ~= -1)
RECLIST = textscan(fid,'%s'); 
RECORDS=RECLIST{1};
else
    error(['Could not open ' reffile ' for scoring. Exiting...'])
end
%fid=fopen([data_dir DATAFILE], 'r' )
%A= fread(fid, inf, 'uint8')';  % matrix with 3 rows, each 8 bits long, = 2*12bit
for i=13:21
    
filename = RECORDS{i,1};
wfdb2mat(filename)
end
%% 

clear all
data_dir= [pwd filesep 'Intracardiac Atrial Fibrillation Database' filesep];
%DATAFILE='a01.dat';        
recordName= [ data_dir filesep 'RECORDS'];
fid = fopen(recordName, 'r');
if(fid ~= -1)
RECLIST = textscan(fid,'%s'); 
RECORDS=RECLIST{1};
else
    error(['Could not open ' reffile ' for scoring. Exiting...'])
end

for i=1:32
    
data_dir= [pwd filesep 'Intracardiac Atrial Fibrillation Database' filesep];    
filename = RECORDS{i,1};
%CC=split(filename,"/");
%filename1=CC{2}
filename1=filename;
%wfdb2mat(filename)
filename2=strcat(filename1, 'm');
AA =load(filename2);
BBB=AA.val(1,:);
%[p,q] = rat(300/128,0.0001)
DD=resample(BBB,3,10);

data_dir= [pwd filesep 'Intracardiac Atrial Fibrillation Database_New' filesep filename2 filesep];

save(data_dir,'DD');

end


%%

%clear all
data_dir= [pwd filesep 'AF Termination' filesep];
%DATAFILE='a01.dat';        
recordName= [ data_dir filesep 'RECORDS'];
fid = fopen(recordName, 'r');
if(fid ~= -1)
RECLIST = textscan(fid,'%s'); 
RECORDS=RECLIST{1};
else
    error(['Could not open ' reffile ' for scoring. Exiting...'])
end

for i=2:80
    
data_dir= [pwd filesep 'DATA_for_TEST' filesep 'AF Termination' filesep];    
filename = RECORDS{i,1};
CC=split(filename,"/");
filename1=CC{2}
%filename1=filename;
%wfdb2mat(filename)
filename2=strcat(filename1, 'm');
load(filename2, '-mat');

AF_sample{i+32,1}=DD


end

%%  FB Coeff

QRS_value = cellfun(@(x)qrs_detect2(x',0.25,0.6,300)',ECG1,'UniformOutput',false);

RR_int = cellfun(@(x)diff(x')/300,QRS_value,'UniformOutput',false);

FBCC = cellfun(@(x)fourierbessel((x)),RR_int,'UniformOutput',false);

FBCC1_tran1 = cellfun(@(x)interp1(x,0:(length(x)/110):(length(x))),FBCC,'UniformOutput',false);
FBCC1_tran2=cellfun(@(x)[x(12:end)],FBCC1_tran1,'UniformOutput',false);

FBCC1_tran=FBCC1_tran2;

i=7
plot(FBCC1_tran{i, 1})
i=i+1
% reffile = ['validation' filesep 'REFERENCE.csv'];
% fid = fopen(reffile, 'r');
% if(fid ~= -1)
%     RECLIST = textscan(fid,'%s'); 
%     RECORDS=RECLIST{1};
%     % %s','Delimiter',',');
% else
%     error(['Could not open ' reffile ' for scoring. Exiting...'])
% end
% fclose(fid);
% 
% RECORDS = Ref{1};
% target  = Ref{2};
% N       = length(RECORDS);
% 
% a = find(strcmp(ANSWERS{2},'N'));
% b = find(strcmp(ANSWERS{2},'A'));
% c = find(strcmp(ANSWERS{2},'O'));
% d = find(strcmp(ANSWERS{2},'~'));
% ln = length(a)+length(b)+length(c)+length(d);

%% In House data

clear all
%data_dir= [pwd filesep 'AF Termination' filesep];
data_dir= [pwd];
%DATAFILE='a01.dat';        
recordName= [ data_dir filesep 'RECORDS2'];
fid = fopen(recordName, 'r');
if(fid ~= -1)
RECLIST = textscan(fid,'%s'); 
RECORDS=RECLIST{1};
else
    error(['Could not open ' reffile ' for scoring. Exiting...'])
end
%fid=fopen([data_dir DATAFILE], 'r' )
%A= fread(fid, inf, 'uint8')';  % matrix with 3 rows, each 8 bits long, = 2*12bit
for i=256:307

filename = RECORDS{i,1};

data_dir= [pwd filesep 'matlab_data_TW' filesep filename  ];   
load(data_dir, '-mat')
ECG1=(data(datastart(3):datastart(4)));
% ECG1=(data(datastart(4):end));
data_dir= [pwd filesep '2NAK2' filesep filename filesep];    
save(data_dir,'ECG1');
end

% range=24,47,75,124,174,194, for second set"matlab_data_TW" no.
% 174,215,222,255

%% 

clear all
%data_dir= [pwd filesep 'AF Termination' filesep];
data_dir= [pwd];
%DATAFILE='a01.dat';        
recordName= [ data_dir filesep 'RECORDS'];
fid = fopen(recordName, 'r');
if(fid ~= -1)
RECLIST = textscan(fid,'%s'); 
RECORDS=RECLIST{1};
else
    error(['Could not open ' reffile ' for scoring. Exiting...'])
end


for i=195:300    
%data_dir= [pwd filesep 'DATA_for_TEST' filesep 'AF Termination' filesep];    
filename = RECORDS{i,1};
BB=load(filename, '-mat');
CC=BB.ECG1(1:1200000);
DD=resample(CC,1,133);
InH_sample{i,1}=DD;
end