% Script for behavioral analysis of socialdoors data
% Reaction times after wins? After losses? Are these different between tasks?

% Jimmy Wyngaarden--July 1, 2022

clear; close all;
maindir = '/Users/jameswyngaarden/Documents/GitHub/istart/social_reward_c/data';
warning off all

% Specify subs
subs = [1001, 1003, 1004, 1006, 1009, 1010, 1012, 1013, 1015, 1016, ... 
    1019, 1021, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1255, 1276, ...
    1286, 1294, 1301, 1302, 1303, 3116, 3122, 3125, 3140, ...
    3143, 3152, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, ...
    3199, 3200, 3206, 3212, 3220];

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

% All four conditions -- Plot with groups
figure
x = 1:2;
bar_data = [mean(data_mat.Doors_Win_RT) mean(data_mat.Social_Win_RT); mean(data_mat.Doors_Loss_RT) mean(data_mat.Social_Loss_RT)];
b=bar(x, bar_data, 'grouped');
title('RT by task condition');
xticks(1:2);
xticklabels({'Wins', 'Losses'});
ylabel('RT');
xlabel('Condition');
ylim([1.6 2.4]);
hold on
%legend('Doors', 'Social');
[lgd, icons, plots, txt] = legend('show');
e1=[(std(data_mat.Doors_Win_RT)/sqrt(length(data_mat.Doors_Win_RT))) (std(data_mat.Social_Win_RT)/sqrt(length(data_mat.Social_Win_RT))); (std(data_mat.Doors_Loss_RT)/sqrt(length(data_mat.Doors_Loss_RT))) (std(data_mat.Social_Loss_RT)/sqrt(length(data_mat.Social_Loss_RT))) ];
ngroups = size(bar_data, 1);
nbars = size(bar_data, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, bar_data(:,i), e1(:,i), 'ko');
end
b(1).FaceColor = '#77AC30';
b(2).FaceColor = '#0072BD';
b;
hold off

% Statistics
disp('Doors Win ~ Social Win');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT,data_mat.Social_Win_RT);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Win ~ Doors Loss');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT,data_mat.Doors_Loss_RT);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Social Win ~ Social Loss');
[h,p,ci,stats]=ttest(data_mat.Social_Win_RT,data_mat.Social_Loss_RT);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Loss ~ Social Loss');
[h,p,ci,stats]=ttest(data_mat.Doors_Loss_RT,data_mat.Social_Loss_RT);
disp(h);
disp(p);
disp(ci);
disp(stats);

% Combining across domain
figure
x = 1:2;
data_mat.Doors=(data_mat.Doors_Win_RT+data_mat.Doors_Loss_RT)/2;
data_mat.Social=(data_mat.Social_Win_RT+data_mat.Social_Loss_RT)/2;

bar_data = [mean(data_mat.Doors); mean(data_mat.Social)];
b=bar(x, bar_data, 'grouped');
title('RT by domain');
xticks(1:2);
xticklabels({'Doors', 'Social'});
ylabel('RT');
xlabel('Condition');
ylim([1.6 2.4]);
hold on
%legend('Doors', 'Social');
%[lgd, icons, plots, txt] = legend('show');
e1=[(std(data_mat.Doors)/sqrt(length(data_mat.Doors))); (std(data_mat.Social)/sqrt(length(data_mat.Social)))];
ngroups = size(bar_data, 1);
nbars = size(bar_data, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, bar_data(:,i), e1(:,i), 'ko');
end
%b(1).FaceColor = '#77AC30';
%b(2).FaceColor = '#0072BD';
b;
hold off

disp('Doors ~ Social');
[h,p,ci,stats]=ttest(data_mat.Doors,data_mat.Social);
disp(h);
disp(p);
disp(ci);
disp(stats);

% Combining across outcomes
figure
x = 1:2;
data_mat.Wins=((data_mat.Doors_Win_RT+data_mat.Social_Win_RT)/2);
data_mat.Losses=((data_mat.Doors_Loss_RT+data_mat.Social_Loss_RT)/2);

bar_data = [mean(data_mat.Wins); mean(data_mat.Losses)];
b=bar(x, bar_data, 'grouped');
title('RT by outcome');
xticks(1:2);
xticklabels({'Wins', 'Losses'});
ylabel('RT');
xlabel('Condition');
ylim([1.6 2.4]);
hold on
%legend('Doors', 'Social');
%[lgd, icons, plots, txt] = legend('show');
e1=[(std(data_mat.Wins)/sqrt(length(data_mat.Wins))); (std(data_mat.Losses)/sqrt(length(data_mat.Losses)))];
ngroups = size(bar_data, 1);
nbars = size(bar_data, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, bar_data(:,i), e1(:,i), 'ko');
end
%b(1).FaceColor = '#77AC30';
%b(2).FaceColor = '#0072BD';
b;
hold off

disp('Wins ~ Losses');
[h,p,ci,stats]=ttest(data_mat.Wins,data_mat.Losses);
disp(h);
disp(p);
disp(ci);
disp(stats);

