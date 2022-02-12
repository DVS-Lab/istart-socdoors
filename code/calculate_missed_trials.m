% Script to determine percentage of missed trials for socialdoors
% Jimmy Wyngaarden, 11 Feb 2022

clear; close all;
maindir = '/data/projects/istart/social_reward_c/data/';
warning off all

% specify subs
subs = [1001, 1002, 1003, 1004, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, ... 
    1019, 1021, 1240, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, ...
    1281, 1282, 1286, 1294, 1300, 1301, 1302, 3101, 3116, 3122, 3125, 3140, ...
    3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3186, 3189, 3190, ...
    1303, 3199, 3200, 3206, 3210, 3212, 3218, 3220, 3223];

% create framework for data_mat; 3 columns, sub ID, doors % missed, social % missed
data_mat = zeros(length(subs),3);

% loop through each sub
for s = 1:length(subs)
    
    % assign sub ID to first column of data_mat
    data_mat(s,1) = subs(s);

    % loop through monetary domain, then social
    task = {'doors', 'socialdoors'};

    for t = 1:length(task)
    
        % build path for data
        sourcedatadir = fullfile(maindir, num2str(subs(s))); %maindir needs to be istart/social_reward_c/data/
        sourcedata = dir([sourcedatadir '/sub-' num2str(subs(s)) '_task-' task{t} '_run-01_events.tsv*']);
        T = readtable(sourcedata.name);
        
        % isolate decision phase
        alltrials = T.trialtype == "decision" | T.trialtype == "decision-missed";
        missedtrials = T.trialtype == "decision-missed";
        
        % calculate proportion of missed trials
        prop_missed = length(missedtrials)/length(alltrials);
        
        % assign missed trials value to data_mat
        if task{t} == 'doors'
            data_mat(s,2) = prop_missed;
        else
            data_mat(s,3) = prop_missed;
        end
        
    end
end