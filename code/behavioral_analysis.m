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
% RT doors after loss, RT social after win, RT social after loss for t+1, 
% t+2, and t+1 relative change
data_mat = zeros(length(subs),13);

%% Calculate avg RTs & relative change in RT
for s = 1:length(subs)
    %s=1;
    data_mat(s,1) = subs(s);
    task = {'doors', 'socialdoors'};

    for f = 1:length(task)
        sourcedatadir = fullfile(maindir, num2str(subs(s)));
        sourcedata = fullfile([sourcedatadir '/sub-' num2str(subs(s)) '_task-' task{f} '_run-1_events.tsv']);

        % Confirm that file exists
        if isfile(sourcedata)
            if f == 1
                doors_file = ['Found doors file ', num2str(subs(s)), ': ', sourcedata];
                disp(doors_file);
            elseif f == 2
                social_file = ['Found social file ', num2str(subs(s)), ': ', sourcedata];
                disp(social_file);
                fprintf(1, '\n');
            end
        else
            missing_message = ['File not found: ', num2str(subs(s)), ' ', task{f}];
            disp(missing_message);
        end

        % Perform calculations
        T = readtable(sourcedata,'FileType','delimitedtext');

        if iscell(T.rt(1))
            T_temp = zeros(length(T.rt),1);
            for t = 1:length(T.rt)
                if isequal(T.rt(t), 'n/a')
                    T_temp(t) = NaN;
                else
                    T_temp(t) = str2double(T.rt(t));
                end
            end
            T.rt = T_temp;
        end

        % Prespecify matrices
        win_mat = zeros(30,6);
        w = 1;
        loss_mat = zeros(30,6);
        l = 1;

        % Loop through individual trials within subs
        for t = 2:(length(T.rt)-1)
            if T.trial_type{t}=="win"
                % Record trial number
                win_mat(w,1) = t;

                % Record current trial type
                if isequal(T.trial_type(t),{'win'})
                    win_mat(w,2) = 1;
                else
                    win_mat(w,2) = 0;
                end

                % Record following trial type
                if t < (length(T.rt)-2)
                    if isequal(T.trial_type(t+2),{'win'})
                        win_mat(w,3) = 1;
                    else
                        win_mat(w,3) = 0;
                    end
                else
                     win_mat(w,3) = NaN;
                end
        
                % Record RT at t+1
                win_mat(w,4) = T.rt(t+1);

                % Record RT at t+2
                if t < (length(T.rt)-2)
                    win_mat(w,5) = T.rt(t+3);
                else
                    win_mat(w,5) = nan;
                end
                     
                % Record relative change in RT at t+1
                win_mat(w,6)=(T.rt(t+1)-T.rt(t-1))/(T.rt(t-1));

                % Add to win_mat count
                w = w+1;
            end
            
            % Repeat for loss trials
            if T.trial_type{t}=="loss"
                loss_mat(l,1) = t;
                if isequal(T.trial_type(t),{'loss'})
                    loss_mat(w,2) = 0;
                else
                    loss_mat(w,2) = 1;
                end
                if t < (length(T.rt)-2)
                    if isequal(T.trial_type(t+2),{'loss'})
                        loss_mat(w,3) = 0;
                    else
                        loss_mat(w,3) = 1;
                    end
                else
                     loss_mat(w,3) = NaN;
                end
                loss_mat(l,4) = T.rt(t+1);
                if t < (length(T.rt)-2)
                    loss_mat(l,5) = T.rt(t+3);
                else
                    loss_mat(l,5) = nan;
                end
                loss_mat(l,6)=(T.rt(t+1)-T.rt(t-1))/(T.rt(t-1));
                l = l+1;
            end
        end
        
        % Remove zeros from trial arrays
        win_mat = win_mat(any(win_mat,2),:);
        win_mat(isnan(win_mat(:,2)),:)=[];
        loss_mat = loss_mat(any(loss_mat,2),:);
        loss_mat(isnan(loss_mat(:,2)),:)=[];

        % Find avg. RT and assign to data_mat
        if f==1
            data_mat(s,2)=nanmean(win_mat(:,4));
            data_mat(s,3)=nanmean(loss_mat(:,4));
            data_mat(s,6)=nanmean(win_mat(:,5));
            data_mat(s,7)=nanmean(loss_mat(:,5));
            data_mat(s,10)=nanmean(win_mat(:,6));
            data_mat(s,11)=nanmean(loss_mat(:,6));
        elseif f==2
            data_mat(s,4)=nanmean(win_mat(:,4));
            data_mat(s,5)=nanmean(loss_mat(:,4));
            data_mat(s,8)=nanmean(win_mat(:,5));
            data_mat(s,9)=nanmean(loss_mat(:,5));
            data_mat(s,12)=nanmean(win_mat(:,6));
            data_mat(s,13)=nanmean(loss_mat(:,6));
        end

        win_mat = array2table(win_mat);
        win_mat.Properties.VariableNames(1:6)={'Trial','Trial_Type','Next_Trial_Type','Win_RT_t+1','Win_RT_t+2', 'Relative_Change_t+1'};

        loss_mat = array2table(loss_mat);
        loss_mat.Properties.VariableNames(1:6)={'Trial','Trial_Type','Next_Trial_Type','Loss_RT_t+1','Loss_RT_t+2', 'Relative_Change_t+1'};

    end
end

data_mat = array2table(data_mat);
data_mat.Properties.VariableNames(1:13)={'Sub','Doors_Win_RT_t1','Doors_Loss_RT_t1','Social_Win_RT_t1','Social_Loss_RT_t1', 'Doors_Win_RT_t2','Doors_Loss_RT_t2','Social_Win_RT_t2','Social_Loss_RT_t2', 'Doors_Win_Rel_t1','Doors_Loss_Rel_t1','Social_Win_Rel_t1','Social_Loss_Rel_t1'};

%% Plots

% Histogram of conditions
figure

subplot(2,2,1)
histogram(data_mat.Doors_Win_RT_t1, 'FaceColor', '#77AC30');
title('Doors Win t+1');
xlabel('RT');
xlim([0,3]);
ylim([0,20]);

subplot(2,2,2)
histogram(data_mat.Doors_Loss_RT_t1, 'FaceColor', '#77AC30');
title('Doors Loss t+1');
xlabel('RT');
xlim([0,3]);
ylim([0,20]);

subplot(2,2,3)
histogram(data_mat.Social_Win_RT_t1);
title('Social Win t+1');
xlabel('RT');
xlim([0,3]);
ylim([0,20]);

subplot(2,2,4)
histogram(data_mat.Social_Loss_RT_t1);
title('Social Loss t+1');
xlabel('RT');
xlim([0,3]);
ylim([0,20]);

% Histogram of conditions
figure

subplot(2,2,1)
histogram(data_mat.Doors_Win_RT_t2, 'FaceColor', '#77AC30');
title('Doors Win t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,20]);

subplot(2,2,2)
histogram(data_mat.Doors_Loss_RT_t2, 'FaceColor', '#77AC30');
title('Doors Loss t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,20]);

subplot(2,2,3)
histogram(data_mat.Social_Win_RT_t2);
title('Social Win t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,20]);

subplot(2,2,4)
histogram(data_mat.Social_Loss_RT_t2);
title('Social Loss t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,20]);

% Histogram of conditions
figure

subplot(2,2,1)
histogram(data_mat.Doors_Win_Rel_t1, 'FaceColor', '#77AC30');
title('Doors Win Relative Change');
xlabel('RT');

subplot(2,2,2)
histogram(data_mat.Doors_Loss_Rel_t1, 'FaceColor', '#77AC30');
title('Doors Loss Relative Change');
xlabel('RT');

subplot(2,2,3)
histogram(data_mat.Social_Win_Rel_t1);
title('Social Win Relative Change');
xlabel('RT');

subplot(2,2,4)
histogram(data_mat.Social_Loss_Rel_t1);
title('Social Loss Relative Change');
xlabel('RT');

% All four conditions -- Plot with groups
figure
x = 1:2;
bar_data = [mean(data_mat.Doors_Win_RT_t1) mean(data_mat.Social_Win_RT_t1); mean(data_mat.Doors_Loss_RT_t1) mean(data_mat.Social_Loss_RT_t1)];
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
e1=[(std(data_mat.Doors_Win_RT_t1)/sqrt(length(data_mat.Doors_Win_RT_t1))) (std(data_mat.Social_Win_RT_t1)/sqrt(length(data_mat.Social_Win_RT_t1))); (std(data_mat.Doors_Loss_RT_t1)/sqrt(length(data_mat.Doors_Loss_RT_t1))) (std(data_mat.Social_Loss_RT_t1)/sqrt(length(data_mat.Social_Loss_RT_t1))) ];
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
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT_t1,data_mat.Social_Win_RT_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Win ~ Doors Loss');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT_t1,data_mat.Doors_Loss_RT_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Social Win ~ Social Loss');
[h,p,ci,stats]=ttest(data_mat.Social_Win_RT_t1,data_mat.Social_Loss_RT_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Loss ~ Social Loss');
[h,p,ci,stats]=ttest(data_mat.Doors_Loss_RT_t1,data_mat.Social_Loss_RT_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

% Combining across domain
figure
x = 1:2;
data_mat.Doors=(data_mat.Doors_Win_RT_t1+data_mat.Doors_Loss_RT_t1)/2;
data_mat.Social=(data_mat.Social_Win_RT_t1+data_mat.Social_Loss_RT_t1)/2;

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
data_mat.Wins=((data_mat.Doors_Win_RT_t1+data_mat.Social_Win_RT_t1)/2);
data_mat.Losses=((data_mat.Doors_Loss_RT_t1+data_mat.Social_Loss_RT_t1)/2);

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

