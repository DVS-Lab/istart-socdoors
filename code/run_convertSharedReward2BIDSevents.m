% script to run through all subjects
% also makes a table to summarize key information


% set up paths
scriptname = matlab.desktop.editor.getActiveFilename;
[codedir,~,~] = fileparts(scriptname);
cd(codedir);
addpath(codedir);
cd ..
dsdir = pwd;

% list of subjects
sublist = [1001 1002 1003 1004 1006 1007 1009 1010 1011 1012 1013 ...
    1015 1016 1019 1021 1240 1242 1243 1244 1245 1247 1248 1249 1251 1253 ...
    1286 1300];

outdata = zeros(length(sublist),5);
for s = 1:length(sublist)
    out = convertSharedReward2BIDSevents(sublist(s));
    
    outdata(s,1) = out.ntrials(1);
    outdata(s,2) = out.ntrials(2);
    outdata(s,3) = out.nmisses(1);
    outdata(s,4) = out.nmisses(2);
    outdata(s,5) = out.nfiles;
    
end
A = [sublist' outdata];
T = array2table(A,'VariableNames',{'sub','run1_ntrials','run2_ntrials','run1_nmisses','run2_misses','nfiles'});
outfile = fullfile(dsdir,'derivatives',['DataSummary_' date '.csv']);
writetable(T,outfile,'Delimiter',',') 
