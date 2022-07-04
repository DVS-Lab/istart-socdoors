% Script for behavioral analysis of socialdoors data
% Reaction times after wins? After losses? Are these different between tasks?

% Jimmy Wyngaarden--July 1, 2022

clear; close all;
maindir = '/Users/jameswyngaarden/Documents/GitHub/istart/social_reward_c/data';
warning off all

% Specify subs
subs = [1001, 1002, 1003, 1004, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, ... 
    1019, 1021, 1240, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, ...
    1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, ...
    3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3186, 3189, 3190, ...
    3199, 3200, 3206, 3210, 3212, 3218, 3220, 3223];

% Create a framework for data_mat--X columns: sub ID, RT doors after win,
% RT doors after loss, RT social after win, RT social after loss
data_mat = zeros(length(subs),5);

%% Read files & calculate avg. RT

% Loop through each subject
for s = 1:length(subs)
    %s=1;

    % Assign sub ID to first column of data_mat
    data_mat(s,1) = subs(s);

    % Loop through monetary then social domains
    task = {'doors', 'socialdoors'};
    %task = {'doors'};
    for f = 1:length(task)
       %f=1;
        % Build path for data
        sourcedatadir = fullfile(maindir, num2str(subs(s)));
        sourcedata = fullfile([sourcedatadir '/sub-' num2str(subs(s)) '_task-' task{f} '_run-1_events.tsv']);
        
        % Confirm file exists
        if isfile(sourcedata)
        
            % Read file
            T = readtable(sourcedata,'FileType','delimitedtext');
            
            % Isolate wins & losses
            wintrials = T.trial_type == "win";
            losstrials = T.trial_type == "loss";

            % Create framework for win & loss trials
            win_mat = zeros(sum(wintrials),2);
            loss_mat = zeros(sum(losstrials),2);
            
             % Loop through trials
             for t = 1:length(T.trial_type)-1 
                 %t=2;
                if T.trial_type{t} == "win"
                    win_mat(t,1) = t;
                    win_mat(t,2) = str2double(T.rt(t+1));
                end
                 if T.trial_type{t} == "loss"
                    loss_mat(t,1) = t;
                    loss_mat(t,2) = str2double(T.rt(t+1));
                 end
             end
            
             % Remove zeros from trial arrays
             win_mat = win_mat(any(win_mat,2),:);
             win_mat(isnan(win_mat(:,2)),:)=[];             
             loss_mat = loss_mat(any(loss_mat,2),:);
             loss_mat(isnan(loss_mat(:,2)),:)=[];             


             % Find avg. RT and assign to data_mat
             avg_winRT=mean(win_mat(:,2));
             avg_lossRT=mean(loss_mat(:,2));
             if f==1
                 data_mat(s,2)=avg_winRT;
                 data_mat(s,3)=avg_lossRT;
             end
             if f==2
                 data_mat(s,4)=avg_winRT;
                 data_mat(s,5)=avg_lossRT;
             end

             % If avg. RT = NaN, re-run with no str2double
             % wins
             if isnan(avg_winRT)==true
                for t = 1:length(T.trial_type)-1 
                    if T.trial_type{t} == "win"
                        win_mat(t,1) = t;
                        win_mat(t,2) = T.rt(t+1);
                    end
                end
                win_mat = win_mat(any(win_mat,2),:);
                win_mat(isnan(win_mat(:,2)),:)=[];
                
                avg_winRT=mean(win_mat(:,2));
                if f==1
                    data_mat(s,2)=avg_winRT;
                end
                if f==2
                    data_mat(s,4)=avg_winRT;
                end
             end
             % losses
             if isnan(avg_lossRT)==true
                for t = 1:length(T.trial_type)-1 
                    if T.trial_type{t} == "loss"
                        loss_mat(t,1) = t;
                        loss_mat(t,2) = T.rt(t+1);
                    end
                end
                loss_mat = loss_mat(any(loss_mat,2),:);
                loss_mat(isnan(loss_mat(:,2)),:)=[];
                
                avg_lossRT=mean(loss_mat(:,2));
                if f==1
                    data_mat(s,3)=avg_lossRT;
                end
                if f==2
                    data_mat(s,5)=avg_lossRT;
                end
             end

        else

            % Print message if file is missing
            missing_message = ['File not found: ', num2str(subs(s)), ' ', task{f}];
            disp(missing_message);
        end
    end
end

data_mat = array2table(data_mat);
data_mat.Properties.VariableNames(1:5)={'Sub','Doors_Win_RT','Doors_Loss_RT','Social_Win_RT','Social_Loss_RT'};

%% Plots

means = [mean(data_mat.Doors_Win_RT);mean(data_mat.Doors_Loss_RT);mean(data_mat.Social_Win_RT);mean(data_mat.Social_Loss_RT)];
sem1=(std(data_mat.Doors_Win_RT)/sqrt(data_mat.Doors_Win_RT));



