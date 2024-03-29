% Script for behavioral analysis of socialdoors data
% Reaction times after wins? After losses? Are these different between tasks?

% Jimmy Wyngaarden--July 1, 2022

clear; close all;

% Point this to the istart social doors data directory:
maindir = '/Users/jameswyngaarden/Documents/Documents_Air/GitHub/istart/social_reward_c/data';
warning off all

% Specify subs
subs = [1001, 1003, 1004, 1006, 1009, 1010, 1012, 1013, 1015, 1016, ... 
    1019, 1021, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251 ...
    1255, 1276, 1286, 1294, 1301, 1302, 1303, 3116, 3122, 3125 ...
    3140, 3143, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, ...
    3200, 3206, 3212, 3220];



%% No user input required after this line

% Create a framework for data_mat--X columns: sub ID, RT doors after win,
% RT doors after loss, RT social after win, RT social after loss for t+1, 
% t+2, and t+1 relative change
data_mat = zeros(length(subs),29);

% Calculate avg RTs & relative change in RT
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
        doors_wint1 = zeros(30,1);
        social_wint1 = zeros(30,1);
        w = 1;
        loss_mat = zeros(30,6);
        doors_loss = zeros(30,1);
        social_loss = zeros(30,1);
        l = 1;

        % Loop through individual trials within subs
        for t = 2:(length(T.rt)-1)
            if T.trial_type{t}=="win"
                % Record trial number
                win_mat(w,1) = t;

                % Record current (t+1) trial type
                if isequal(T.trial_type(t),{'win'})
                    win_mat(w,2) = 1;
                else
                    win_mat(w,2) = 0;
                end

                % Record following (t+2) trial type
                if t < (length(T.rt)-2)
                    if isequal(T.trial_type(t+2),{'win'})
                        win_mat(w,3) = 1;
                    else
                        win_mat(w,3) = 0;
                    end
                else
                     win_mat(w,3) = NaN;
                end

                % Record RT at t+0
                win_mat(w,4) = T.rt(t-1);
        
                % Record RT at t+1
                win_mat(w,5) = T.rt(t+1);
                if f==1
                    doors_wint1(w,1) = T.rt(t+1);
                else
                    social_wint1(w,1) = T.rt(t+1);
                end

                % Record RT at t+2
                if t < (length(T.rt)-2)
                    win_mat(w,6) = T.rt(t+3);
                else
                    win_mat(w,6) = nan;
                end
                     
                % Record relative change in RT at t+1
                win_mat(w,7)=(T.rt(t+1)-T.rt(t-1))/(T.rt(t-1));

                % Add to win_mat count
                w = w+1;
            end
            
            % Repeat previous loop for loss trials
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
                loss_mat(l,4) = T.rt(t-1);
                loss_mat(l,5) = T.rt(t+1);
                if f==1
                    doors_loss1(w,1) = T.rt(t+1);
                else
                    social_losst1(w,1) = T.rt(t+1);
                end
                if t < (length(T.rt)-2)
                    loss_mat(l,6) = T.rt(t+3);
                else
                    loss_mat(l,6) = nan;
                end
                loss_mat(l,7)=(T.rt(t+1)-T.rt(t-1))/(T.rt(t-1));
                l = l+1;
            end
        end
        
        % Remove any zeros from trial arrays
        win_mat = win_mat(any(win_mat,2),:);
        win_mat(isnan(win_mat(:,2)),:)=[];
        loss_mat = loss_mat(any(loss_mat,2),:);
        loss_mat(isnan(loss_mat(:,2)),:)=[];

        % Track t+2--is t+2 congruent or incongruent with t?
        t2_wins1 = zeros(20,2);
        t2_wins2 = zeros(20,2);
        t2_losses1 = zeros(20,2);
        t2_losses2 = zeros(20,2);
        ww = 1;
        wl = 1;
        ll = 1;
        lw = 1;
        
        % Store t+2 in t2_wins1 if it is also a win, t2_wins2 if it a loss
        for u = 1:length(win_mat(:,2))
            if isequal(win_mat(u,3),1)
                t2_wins1(ww,1) = u;
                t2_wins1(ww,2) = win_mat(u,6);
                ww = ww+1;
            elseif isequal(win_mat(u,3),0)
                t2_wins2(ww,1) = u;
                t2_wins2(wl,2) = win_mat(u,6);
                wl = wl+1;
            end
        end
        
        % Repeat for t2_losses
        for u = 1:length(loss_mat(:,2))
            if isequal(loss_mat(u,3),0)
                t2_losses1(ll,1) = u;
                t2_losses1(ll,2) = loss_mat(u,6);
                ll = ll+1;
            elseif isequal(loss_mat(u,3),1)
                t2_losses2(ll,1) = u;
                t2_losses2(lw,2) = loss_mat(u,6);
                lw = lw+1;
            end
        end
        
        % Remove any zeroes from t2 trials
        t2_wins1 = t2_wins1(any(t2_wins1,2),:);
        t2_wins2 = t2_wins2(any(t2_wins2,2),:);
        t2_losses1 = t2_losses1(any(t2_losses1,2),:);
        t2_losses2 = t2_losses2(any(t2_losses2,2),:);

        % Find avg. RT and assign to data_mat for doors trials
        if f==1
            % Doors Win RT t+0
            data_mat(s,2)=nanmean(win_mat(:,4));
            % Doors Loss RT t+0
            data_mat(s,3)=nanmean(loss_mat(:,4));
            % Doors Win RT t+1
            data_mat(s,6)=nanmean(win_mat(:,5));
            % Doors Loss RT t+1
            data_mat(s,7)=nanmean(loss_mat(:,5));
            % Doors Win RT t+2
            data_mat(s,10)=nanmean(win_mat(:,6));
            % Doors Loss RT t+2
            data_mat(s,11)=nanmean(loss_mat(:,6));
            % Doors Win Rel Change t+1
            data_mat(s,14)=nanmean(win_mat(:,7));
            % Doors Loss Rel Change t+1
            data_mat(s,15)=nanmean(loss_mat(:,7));
            % Doors Win Cong t+2
            data_mat(s,18)=nanmean(t2_wins1(:,2));
            % Doors Win Incong t+2
            data_mat(s,19)=nanmean(t2_wins2(:,2));
            % Doors Loss Cong t+2
            data_mat(s,20)=nanmean(t2_losses1(:,2));
            % Doors Loss Incong t+2
            data_mat(s,21)=nanmean(t2_losses2(:,2));
            data_mat(s,26)=length(T.rt);
        % Repeat for social trials
        elseif f==2
            data_mat(s,4)=nanmean(win_mat(:,4));
            data_mat(s,5)=nanmean(loss_mat(:,4));
            data_mat(s,8)=nanmean(win_mat(:,5));
            data_mat(s,9)=nanmean(loss_mat(:,5));
            data_mat(s,12)=nanmean(win_mat(:,6));
            data_mat(s,13)=nanmean(loss_mat(:,6));
            data_mat(s,16)=nanmean(win_mat(:,7));
            data_mat(s,17)=nanmean(loss_mat(:,7));
            data_mat(s,22)=nanmean(t2_wins1(:,2));
            data_mat(s,23)=nanmean(t2_wins2(:,2));
            data_mat(s,24)=nanmean(t2_losses1(:,2));
            data_mat(s,25)=nanmean(t2_losses2(:,2));
            data_mat(s,27)=length(T.rt);
        end
        
        % Write labels for win_mat & loss_mat dfs
        win_mat = array2table(win_mat);
        win_mat.Properties.VariableNames(1:7)={'Trial','Trial_Type','Next_Trial_Type','Win_RT_t+0','Win_RT_t+1','Win_RT_t+2', 'Relative_Change_t+1'};
        loss_mat = array2table(loss_mat);
        loss_mat.Properties.VariableNames(1:7)={'Trial','Trial_Type','Next_Trial_Type','Loss_RT_t+0','Loss_RT_t+1','Loss_RT_t+2', 'Relative_Change_t+1'};
    end
end

% Calculate percent RT change
% Percent change = (win(t+1) - loss(t+1)) / win(t+1)

% Make sure to double that these columns & vars match up correctly; Write
% these as vars instead of using column index

for k = 1:length(data_mat(:,6))
    data_mat(k,28) = (data_mat(k,6) - data_mat(k,7))/data_mat(k,6);
    data_mat(k,29) = (data_mat(k,8) - data_mat(k,9))/data_mat(k,8);
end


% Write labels for data_mat
data_mat = array2table(data_mat);
data_mat.Properties.VariableNames(1:29)={'Sub','Doors_Win_RT_t0','Doors_Loss_RT_t0','Social_Win_RT_t0','Social_Loss_RT_t0','Doors_Win_RT_t1','Doors_Loss_RT_t1','Social_Win_RT_t1','Social_Loss_RT_t1','Doors_Win_RT_t2','Doors_Loss_RT_t2','Social_Win_RT_t2','Social_Loss_RT_t2','Doors_Win_Rel_t1','Doors_Loss_Rel_t1','Social_Win_Rel_t1','Social_Loss_Rel_t1','Doors_Win_Cong_t2','Doors_Win_Incong_t2','Doors_Loss_Cong_t2','Doors_Loss_Incong_t2','Social_Win_Cong_t2','Social_Win_Incong_t2','Social_Loss_Cong_t2','Social_Loss_Incong_t2', 'Doors Length', 'Social Length', 'Percent_Change_Doors', 'Percent_Change_Soc'};

filename = 'RT_data.xlsx';
writetable(data_mat,filename,'Sheet',1,'Range','D1')

%% Plots: Histogram of conditions, t+1
figure

subplot(2,2,1)
histogram(data_mat.Doors_Win_RT_t1, 10, 'FaceColor', '#77AC30');
title('Doors Win t+1');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,2)
histogram(data_mat.Doors_Loss_RT_t1, 10, 'FaceColor', '#77AC30');
title('Doors Loss t+1');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,3)
histogram(data_mat.Social_Win_RT_t1, 10);
title('Social Win t+1');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,4)
histogram(data_mat.Social_Loss_RT_t1, 10);
title('Social Loss t+1');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

% Replication of the original histograms for replication purposes
figure

subplot(2,2,1)
hist(data_mat.Doors_Win_RT_t1);
title('Doors Win t+1');
xlabel('RT');
xlim([1,3]);
ylim([0,10]);

subplot(2,2,2)
hist(data_mat.Doors_Loss_RT_t1);
title('Doors Loss t+1');
xlabel('RT');
xlim([1,3]);
ylim([0,10]);

subplot(2,2,3)
hist(data_mat.Social_Win_RT_t1);
title('Social Win t+1');
xlabel('RT');
xlim([1,3]);
ylim([0,10]);

subplot(2,2,4)
hist(data_mat.Social_Loss_RT_t1);
title('Social Loss t+1');
xlabel('RT');
xlim([1,3]);
ylim([0,10]);

%% Histogram of conditions, t+0
figure

subplot(2,2,1)
histogram(data_mat.Doors_Win_RT_t0, 10, 'FaceColor', '#77AC30');
title('Doors Win t+0');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,2)
histogram(data_mat.Doors_Loss_RT_t0, 10, 'FaceColor', '#77AC30');
title('Doors Loss t+0');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,3)
histogram(data_mat.Social_Win_RT_t0, 10);
title('Social Win t+0');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,4)
histogram(data_mat.Social_Loss_RT_t0, 10);
title('Social Loss t+0');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

%% Histogram of conditions, t+2
figure

subplot(2,2,1)
histogram(data_mat.Doors_Win_RT_t2, 10, 'FaceColor', '#77AC30');
title('Doors Win t+2');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,2)
histogram(data_mat.Doors_Loss_RT_t2, 10, 'FaceColor', '#77AC30');
title('Doors Loss t+2');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,3)
histogram(data_mat.Social_Win_RT_t2, 10);
title('Social Win t+2');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

subplot(2,2,4)
histogram(data_mat.Social_Loss_RT_t2, 10);
title('Social Loss t+2');
xlabel('RT');
xlim([1,2.7]);
ylim([0,10]);

%% Histogram of conditions, Relative change, t+1
figure

subplot(2,2,1)
histogram(data_mat.Doors_Win_Rel_t1, 10, 'FaceColor', '#77AC30');
title('Doors Win Relative Change');
xlabel('RT');
xlim([-.06,.11]);
ylim([0,10]);

subplot(2,2,2)
histogram(data_mat.Doors_Loss_Rel_t1, 10, 'FaceColor', '#77AC30');
title('Doors Loss Relative Change');
xlabel('RT');
xlim([-.06,.11]);
ylim([0,10]);

subplot(2,2,3)
histogram(data_mat.Social_Win_Rel_t1, 10);
title('Social Win Relative Change');
xlabel('RT');
xlim([-.06,.11]);
ylim([0,10]);

subplot(2,2,4)
histogram(data_mat.Social_Loss_Rel_t1, 10);
title('Social Loss Relative Change');
xlabel('RT');
xlim([-.06,.11]);
ylim([0,10]);

%% Histogram of conditions, Congruent vs Incongruent, t+2
figure

subplot(2,4,1)
histogram(data_mat.Doors_Win_Cong_t2, 'FaceColor', '#77AC30');
title('Doors Win Congruent t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,25]);

subplot(2,4,2)
histogram(data_mat.Doors_Win_Incong_t2, 'FaceColor', '#77AC30');
title('Doors Win Incongruent t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,25]);

subplot(2,4,5)
histogram(data_mat.Doors_Loss_Cong_t2, 'FaceColor', '#77AC30');
title('Doors Loss Congruent t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,25]);

subplot(2,4,6)
histogram(data_mat.Doors_Loss_Incong_t2, 'FaceColor', '#77AC30');
title('Doors Loss Incongruent t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,25]);

subplot(2,4,3)
histogram(data_mat.Social_Win_Cong_t2);
title('Social Win Congruent t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,25]);

subplot(2,4,4)
histogram(data_mat.Social_Win_Incong_t2);
title('Social Win Incongruent t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,25]);

subplot(2,4,7)
histogram(data_mat.Social_Loss_Cong_t2);
title('Social Loss Congruent t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,25]);

subplot(2,4,8)
histogram(data_mat.Social_Loss_Incong_t2);
title('Social Loss Incongruent t+2');
xlabel('RT');
xlim([0,3]);
ylim([0,25]);

%% All four t+1 conditions -- Plot with groups
figure
x = 1:2;
bar_data = [mean(data_mat.Doors_Win_RT_t1) mean(data_mat.Doors_Loss_RT_t1); mean(data_mat.Social_Win_RT_t1) mean(data_mat.Social_Loss_RT_t1)];
b=bar(x, bar_data);
title('RT by task condition, t+1');
xticks(1:2);
xticklabels({'Doors', 'Social'});
ylabel('RT');
xlabel('Condition');
ylim([1.6 2.4]);
hold on
%legend('Doors', 'Social');
%[lgd, icons, plots, txt] = legend('show');
e1=[(std(data_mat.Doors_Win_RT_t1)/sqrt(length(data_mat.Doors_Win_RT_t1))) (std(data_mat.Doors_Loss_RT_t1)/sqrt(length(data_mat.Doors_Loss_RT_t1))) ; (std(data_mat.Social_Win_RT_t1)/sqrt(length(data_mat.Social_Win_RT_t1))) (std(data_mat.Social_Loss_RT_t1)/sqrt(length(data_mat.Social_Loss_RT_t1))) ];
ngroups = size(bar_data, 1);
nbars = size(bar_data, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, bar_data(:,i), e1(:,i), 'ko');
end
% b(1).FaceColor = '#77AC30';
% b(2).FaceColor = '#0072BD';
% b;
hold off

% Statistics
disp('Doors Win ~ Social Win, t+1');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT_t1,data_mat.Social_Win_RT_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Win ~ Doors Loss, t+1');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT_t1,data_mat.Doors_Loss_RT_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Social Win ~ Social Loss, t+1');
[h,p,ci,stats]=ttest(data_mat.Social_Win_RT_t1,data_mat.Social_Loss_RT_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Loss ~ Social Loss, t+1');
[h,p,ci,stats]=ttest(data_mat.Doors_Loss_RT_t1,data_mat.Social_Loss_RT_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

%% All four t+0 conditions -- Plot with groups
figure
x = 1:2;
bar_data = [mean(data_mat.Doors_Win_RT_t0) mean(data_mat.Doors_Loss_RT_t0); mean(data_mat.Social_Win_RT_t0) mean(data_mat.Social_Loss_RT_t0)];
b=bar(x, bar_data, 'grouped');
title('RT by task condition, t+0');
xticks(1:2);
xticklabels({'Doors', 'Social'});
ylabel('RT');
xlabel('Condition');
ylim([1.6 2.4]);
hold on
%legend('Doors', 'Social');
%[lgd, icons, plots, txt] = legend('show');
e1=[(std(data_mat.Doors_Win_RT_t0)/sqrt(length(data_mat.Doors_Win_RT_t0))) (std(data_mat.Doors_Loss_RT_t0)/sqrt(length(data_mat.Doors_Loss_RT_t0))); (std(data_mat.Social_Win_RT_t0)/sqrt(length(data_mat.Social_Win_RT_t0))) (std(data_mat.Social_Loss_RT_t0)/sqrt(length(data_mat.Social_Loss_RT_t0))) ];
ngroups = size(bar_data, 1);
nbars = size(bar_data, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, bar_data(:,i), e1(:,i), 'ko');
end
% b(1).FaceColor = '#77AC30';
% b(2).FaceColor = '#0072BD';
% b;
hold off

% Statistics
disp('Doors Win ~ Social Win, t+0');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT_t0,data_mat.Social_Win_RT_t0);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Win ~ Doors Loss, t+0');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT_t0,data_mat.Doors_Loss_RT_t0);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Social Win ~ Social Loss, t+0');
[h,p,ci,stats]=ttest(data_mat.Social_Win_RT_t0,data_mat.Social_Loss_RT_t0);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Loss ~ Social Loss, t+0');
[h,p,ci,stats]=ttest(data_mat.Doors_Loss_RT_t0,data_mat.Social_Loss_RT_t0);
disp(h);
disp(p);
disp(ci);
disp(stats);

%% All four t+2 conditions -- Plot with groups
figure
x = 1:2;
bar_data = [mean(data_mat.Doors_Win_RT_t2) mean(data_mat.Doors_Loss_RT_t2); mean(data_mat.Social_Win_RT_t2) mean(data_mat.Social_Loss_RT_t2)];
b=bar(x, bar_data, 'grouped');
title('RT by task condition, t+2');
xticks(1:2);
xticklabels({'Doors', 'Social'});
ylabel('RT');
xlabel('Condition');
ylim([1.6 2.4]);
hold on
%legend('Doors', 'Social');
[lgd, icons, plots, txt] = legend('show');
e1=[(std(data_mat.Doors_Win_RT_t2)/sqrt(length(data_mat.Doors_Win_RT_t2))) (std(data_mat.Doors_Loss_RT_t2)/sqrt(length(data_mat.Doors_Loss_RT_t2))); (std(data_mat.Social_Win_RT_t2)/sqrt(length(data_mat.Social_Win_RT_t2))) (std(data_mat.Social_Loss_RT_t2)/sqrt(length(data_mat.Social_Loss_RT_t2))) ];
ngroups = size(bar_data, 1);
nbars = size(bar_data, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, bar_data(:,i), e1(:,i), 'ko');
end
% b(1).FaceColor = '#77AC30';
% b(2).FaceColor = '#0072BD';
% b;
hold off

% Statistics
disp('Doors Win ~ Social Win, t+2');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT_t2,data_mat.Social_Win_RT_t2);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Win ~ Doors Loss, t+2');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_RT_t2,data_mat.Doors_Loss_RT_t2);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Social Win ~ Social Loss, t+2');
[h,p,ci,stats]=ttest(data_mat.Social_Win_RT_t2,data_mat.Social_Loss_RT_t2);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Loss ~ Social Loss, t+2');
[h,p,ci,stats]=ttest(data_mat.Doors_Loss_RT_t2,data_mat.Social_Loss_RT_t2);
disp(h);
disp(p);
disp(ci);
disp(stats);

%% All four Relative conditions -- Plot with groups
figure
x = 1:2;
bar_data = [mean(data_mat.Doors_Win_Rel_t1) mean(data_mat.Social_Win_Rel_t1); mean(data_mat.Doors_Loss_Rel_t1) mean(data_mat.Social_Loss_Rel_t1)];
b=bar(x, bar_data, 'grouped');
title('RT by task condition, Relative Change');
xticks(1:2);
xticklabels({'Wins', 'Losses'});
ylabel('RT');
xlabel('Condition');
ylim([0 .06]);
hold on
%legend('Doors', 'Social');
[lgd, icons, plots, txt] = legend('show');
%legend('Doors', 'Social'); 
e1=[(std(data_mat.Doors_Win_Rel_t1)/sqrt(length(data_mat.Doors_Win_Rel_t1))) (std(data_mat.Social_Win_Rel_t1)/sqrt(length(data_mat.Social_Win_Rel_t1))); (std(data_mat.Doors_Loss_Rel_t1)/sqrt(length(data_mat.Doors_Loss_Rel_t1))) (std(data_mat.Social_Loss_Rel_t1)/sqrt(length(data_mat.Social_Loss_Rel_t1))) ];
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
disp('Doors Win ~ Social Win, Rel');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_Rel_t1,data_mat.Social_Win_Rel_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Win ~ Doors Loss, Rel');
[h,p,ci,stats]=ttest(data_mat.Doors_Win_Rel_t1,data_mat.Doors_Loss_Rel_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Social Win ~ Social Loss, Rel');
[h,p,ci,stats]=ttest(data_mat.Social_Win_Rel_t1,data_mat.Social_Loss_Rel_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

disp('Doors Loss ~ Social Loss, Rel');
[h,p,ci,stats]=ttest(data_mat.Doors_Loss_Rel_t1,data_mat.Social_Loss_Rel_t1);
disp(h);
disp(p);
disp(ci);
disp(stats);

%% Combining across domain, t+1
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

%% Combining across domain, Rel
figure
x = 1:2;
data_mat.Doors=(data_mat.Doors_Win_Rel_t1+data_mat.Doors_Loss_Rel_t1)/2;
data_mat.Social=(data_mat.Social_Win_Rel_t1+data_mat.Social_Loss_Rel_t1)/2;

bar_data = [mean(data_mat.Doors); mean(data_mat.Social)];
b=bar(x, bar_data, 'grouped');
title('RT by domain');
xticks(1:2);
xticklabels({'Doors', 'Social'});
ylabel('RT');
xlabel('Condition');
%ylim([1.6 2.4]);
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

%% Combining across outcomes, t+1
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

%% Combining across outcomes, Rel
figure
x = 1:2;
data_mat.Wins=((data_mat.Doors_Win_Rel_t1+data_mat.Social_Win_Rel_t1)/2);
data_mat.Losses=((data_mat.Doors_Loss_Rel_t1+data_mat.Social_Loss_Rel_t1)/2);

bar_data = [mean(data_mat.Wins); mean(data_mat.Losses)];
b=bar(x, bar_data, 'grouped');
title('RT by outcome');
xticks(1:2);
xticklabels({'Wins', 'Losses'});
ylabel('RT');
xlabel('Condition');
%ylim([1.6 2.4]);
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

%% Comparisons within tasks, across time points

figure
x = 1:3;
bar_data = [mean(data_mat.Doors_Loss_RT_t0); mean(data_mat.Doors_Loss_RT_t1); mean(data_mat.Doors_Loss_RT_t2)];
b=bar(x, bar_data, 'grouped');
title('RTs Across Doors Losses');
xticks(1:3);
xticklabels({'t+0', 't+1', 't+2'});
ylabel('RT');
xlabel('Time Point');
%ylim([1.6 2.4]);
hold on
%legend('Doors', 'Social');
%[lgd, icons, plots, txt] = legend('show');
e1=[(std(data_mat.Doors_Loss_RT_t0/sqrt(length(data_mat.Doors_Loss_RT_t0))); (std(data_mat.Doors_Loss_RT_t1)/sqrt(length(data_mat.Doors_Loss_RT_t1))); (std(data_mat.Doors_Loss_RT_t2)/sqrt(length(data_mat.Doors_Loss_RT_t2)))];
ngroups = size(bar_data, 1);
nbars = size(bar_data, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, bar_data(:,i), e1(:,i), 'ko');
end

disp('Doors Losses');
[h,p,ci,stats]=ttest(data_mat.Wins,data_mat.Losses);
disp(h);
disp(p);
disp(ci);
disp(stats);

