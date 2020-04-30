input_directory='E:\Physionet_2020\Training_WFDB'; 
%output_directory='E:\Physionet_2020\output';
fs=500;
addpath(genpath('Tools/'))
       % load('HRVparams_12ECG','HRVparams')
        input_files = {};
        for f = dir(input_directory)'
        if exist(fullfile(input_directory, f.name), 'file') == 2 && f.name(1) ~= '.' && all(f.name(end - 2 : end) == 'mat')
            input_files{end + 1} = f.name;
        end
    end
for i=1:1:size(input_files,2)
    k=i
    
        file_tmp=strsplit(input_files{i},'.');
        tmp_input_file = fullfile(input_directory, file_tmp{1});
        [data,header_data] = load_challenge_data(tmp_input_file);
        if size(data,2)<5000
            ecg11 = [data(2,:) data(2,:)];
            ecg22=ecg11(:,1:5000);
        else
        ecg22=data(2,1:5000);
        
        end
        ecg=BP_filter_ECG(ecg22,fs);
        feat(i,:)=feat_29_2020(ecg);
        
	
        
          
end