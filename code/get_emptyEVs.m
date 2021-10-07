sublist = [104 105 106 107 108 109 110 111 112 113 115 116 ...
    117 118 120 121 122 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 140 141 142 ...
    143 144 145 147 149:159];


%% Shared Reward
%{

run-01_event_computer_neutral.txt
run-01_event_computer_punish.txt
run-01_event_computer_reward.txt
run-01_event_friend_neutral.txt
run-01_event_friend_punish.txt
run-01_event_friend_reward.txt
run-01_event_stranger_neutral.txt
run-01_event_stranger_punish.txt
run-01_event_stranger_reward.txt
run-01_missed_trial.txt

%}

% set paths
codedir = pwd;
cd ..
maindir = pwd;
cd(codedir);


partners = {'computer','friend','stranger'};
outcomes = {'neutral','punish','reward'};

outdata = zeros(length(sublist)*2,10);
idx1 = 0;
for s = 1:length(sublist)
    for r = 1:2
        idx1 = idx1 + 1;
        sub = sublist(s);
        EVdir = fullfile(maindir,'derivatives','fsl','EVfiles',['sub-' num2str(sub)],'sharedreward');
        idx2 = 0;
        for p = 1:length(partners)
            for o = 1:length(outcomes)
                fname = sprintf('run-%02d_event_%s_%s.txt',r,partners{p},outcomes{o});
                evfile = fullfile(EVdir,fname);
                idx2 = idx2 + 1;
                if exist(evfile,'file')
                    x = load(evfile);
                    outdata(idx1,idx2) = size(x,1);
                else
                    outdata(idx1,idx2) = 0;
                end
            end
        end
        
        fname = sprintf('run-%02d_missed_trial.txt',r);
        evfile = fullfile(EVdir,fname);
        if exist(evfile,'file')
            x = load(evfile);
            outdata(idx1,10) = size(x,1);
        else
            outdata(idx1,10) = 0;
        end
        
    end
end



fname = fullfile(maindir,'derivatives','summary_emptyEVs_task-sharedreward.csv');
fid = fopen(fname,'w');
fprintf(fid,'sub,run,computer_neutral,computer_punish,computer_reward,friend_neutral,friend_punish,friend_reward,stranger_neutral,stranger_punish,stranger_reward,missed_trial\n');
idx = 0;
for s = 1:length(sublist)
    for r = 1:2
        idx = idx + 1;
        fprintf(fid,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',sublist(s),r,outdata(idx,:));
    end
end
fclose(fid);



%% Ultimatum Game

%{
ls ../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_*
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_RT.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_RT_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_accept_computer.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_accept_computer_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_accept_ingroup.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_accept_ingroup_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_accept_outgroup.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_accept_outgroup_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_computer.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_computer_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_ingroup.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_ingroup_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_outgroup.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_outgroup_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_reject_computer.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_reject_computer_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_reject_ingroup.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_reject_ingroup_pmod.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_reject_outgroup.txt
../derivatives/fsl/EVfiles/sub-106/ultimatum-pmod/run-02_event_reject_outgroup_pmod.txt
run-02_missed_trial.txt

%}

partners = {'computer','ingroup','outgroup'};
decisions = {'reject','accept'};

outdata = zeros(length(sublist)*2,7);
idx1 = 0;
for s = 1:length(sublist)
    for r = 1:2
        idx1 = idx1 + 1;
        sub = sublist(s);
        EVdir = fullfile(maindir,'derivatives','fsl','EVfiles',['sub-' num2str(sub)],'ultimatum-pmod');
        idx2 = 0;
        for p = 1:length(partners)
            for d = 1:length(decisions)
                
                
                fname = sprintf('run-%02d_event_%s_%s.txt',r,decisions{d},partners{p});
                evfile = fullfile(EVdir,fname);
                idx2 = idx2 + 1;
                if exist(evfile,'file')
                    x = load(evfile);
                    outdata(idx1,idx2) = size(x,1);
                else
                    outdata(idx1,idx2) = 0;
                end
                
            end
        end
        
        fname = sprintf('run-%02d_missed_trial.txt',r);
        evfile = fullfile(EVdir,fname);
        if exist(evfile,'file')
            x = load(evfile);
            outdata(idx1,7) = size(x,1);
        else
            outdata(idx1,7) = 0;
        end
        
    end
end



fname = fullfile(maindir,'derivatives','summary_emptyEVs_task-ultimatum.csv');
fid = fopen(fname,'w');
fprintf(fid,'sub,run,computer_reject,computer_accept,ingroup_reject,ingroup_accept,outgroup_reject,outgroup_accept,missed_trial\n');
idx = 0;
for s = 1:length(sublist)
    for r = 1:2
        idx = idx + 1;
        fprintf(fid,'%d,%d,%d,%d,%d,%d,%d,%d,%d\n',sublist(s),r,outdata(idx,:));
    end
end
fclose(fid);

