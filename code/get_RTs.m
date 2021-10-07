sublist = [104 105 106 107 108 109 110 111 112 113 115 116 ...
    117 118 120 121 122 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 140 141 142 ...
    143 144 145 147 149:159];

% set paths
codedir = pwd;
cd ..
maindir = pwd;
cd(codedir);

RT_data = zeros(length(sublist),3); % sub, trust, ultimatum
for s = 1:length(sublist)
    sub = sublist(s);
    RT_data(s,1) = sublist(s);
    
    if sub == 109 || sub == 110 || sub == 136 || sub == 144 || sub == 145 || sub == 152 || sub == 154 || sub == 156
        nruns = 2;
    elseif sub == 106 || sub == 143
        nruns = 3;
    elseif sub == 134 || sub == 138 || sub == 141 || sub == 149
        nruns = 4;
    else
        nruns = 5;
    end
    
    if sub == 145
        continue
    end
    
    trust_rt = [];
    for r = 1:nruns
        if (sub == 129 && (r == 3 || r == 4 || r == 5)) || (sub == 138 && (r == 3 || r == 4 || r == 5)) || (sub == 118 && r == 3) || (sub == 131 && (r == 2 || r == 3 || r == 5)) || (sub == 111 && r == 1) || (sub == 128 && r == 1) || (sub == 150 && r == 2)
            continue
        end
        if sub == 152
            continue
        end
        
        EVdir = fullfile(maindir,'derivatives','fsl','EVfiles',['sub-' num2str(sub)],'trust');
        tmp_rt = load(fullfile(EVdir,sprintf('run-%02d_choice_computer.txt',r)));
        trust_rt = [trust_rt; tmp_rt];
        tmp_rt = load(fullfile(EVdir,sprintf('run-%02d_choice_friend.txt',r)));
        trust_rt = [trust_rt; tmp_rt];
        tmp_rt = load(fullfile(EVdir,sprintf('run-%02d_choice_stranger.txt',r)));
        trust_rt = [trust_rt; tmp_rt];
    end
    if sub == 152
        RT_data(s,2) = 0;
    else
        RT_data(s,2) = median(trust_rt(:,2));
    end
    
    
    
    ultimatum_rt = [];
    if sub == 120 || sub == 131 || sub == 145
        continue
    end
    
    for r = 1:2
        
        EVdir = fullfile(maindir,'derivatives','fsl','EVfiles',['sub-' num2str(sub)],'ultimatum-rt');
        tmp_rt = load(fullfile(EVdir,sprintf('run-%02d_event_RT_pmod.txt',r)));
        ultimatum_rt = [ultimatum_rt; tmp_rt];
        
    end
    RT_data(s,3) = median(ultimatum_rt(:,3));
end

ultimatum_rt_final = RT_data(RT_data(:,3) > 0,3);
ultimatum_rt_final_z = zscore(ultimatum_rt_final);
ultimatum_subs_final = RT_data(RT_data(:,3) > 0,1);
fname = fullfile(maindir,'derivatives','summary_RTs_task-ultimatum.csv');
fid = fopen(fname,'w');
fprintf(fid,'sub,RT_raw,RT_zscored\n');
for s = 1:length(ultimatum_subs_final)
    fprintf(fid,'%d,%f,%f\n',ultimatum_subs_final(s,1),ultimatum_rt_final(s,1),ultimatum_rt_final_z(s,1));
end
fclose(fid);

trust_rt_final = RT_data(RT_data(:,2) > 0,2);
trust_rt_final_z = zscore(trust_rt_final);
trust_subs_final = RT_data(RT_data(:,2) > 0,1);
fname = fullfile(maindir,'derivatives','summary_RTs_task-trust.csv');
fid = fopen(fname,'w');
fprintf(fid,'sub,RT_raw,RT_zscored\n');
for s = 1:length(trust_subs_final)
    fprintf(fid,'%d,%f,%f\n',trust_subs_final(s,1),trust_rt_final(s,1),trust_rt_final_z(s,1));
end
fclose(fid);


