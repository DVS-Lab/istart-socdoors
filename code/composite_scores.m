clear;
close all;
clc;

% Daniel Sazhin
% ISTART Project (UGDG)
% DVS Lab
% 05/13/2022
% Temple University

% Edited by Jimmy for ISTART-socdoors 05/13/2022

% This code generates a composite reward sensitivity score using BAS and SR
% data. This code also generates a composite substance use score for AUDIT
% and DUDIT.

%% Inputs 

currentdir = pwd;
output_path = currentdir; % Set output path if you would like.

input = 'istart_covariates_composites_raw_30aug22.xlsx'; % input file  %  
%input = 'istart_covariates_raw_data.xlsx';
data = readtable(input);
%Composite_raw = [data.('ID'), data.('BISBAS_BAS'), data.('SPSRWD'), data.('audit_standard_score'), data.('dudit_standard_score')];

%% Jimmy composite test

% Composite substance use score
AUDIT_raw = [data.audit_standard_score];
DUDIT_raw = [data.dudit_standard_score];

%composite_substance = zscore(AUDIT_raw)+zscore(DUDIT_raw);
composite_audit = zscore(AUDIT_raw);
%figure, histogram(composite_substance,50); title('Substance Use Composite')

% Composite reward sensitivity
BAS_raw = [data.BISBAS_BAS];
SPSRWD_raw = [data.SPSRWD];

compRS = zscore(BAS_raw)+zscore(SPSRWD_raw);
% compRS_square = zeros(length(compRS),2);

% for i=1:length(compRS_square)
%     compRS_square(i,1) = compRS(i,1)*compRS(i,1);
%     compRS_square(i,2) = compRS_square(i,1)-mean(compRS_square(:,1));
% end

normedRS = zeros(length(compRS),1); % create empty array for storing data
deciles = prctile(compRS,[10 20 30 40 50 60 70 80 90]); % identify quintiles

% place data into the appropriate quintiles
normedRS(compRS <= deciles(1),1) = 1;
normedRS(compRS > deciles(1) & compRS <= deciles(2),1) = 2;
normedRS(compRS > deciles(2) & compRS <= deciles(3),1) = 3;
normedRS(compRS > deciles(3) & compRS <= deciles(4),1) = 4;
normedRS(compRS > deciles(4) & compRS <= deciles(5),1) = 5;
normedRS(compRS > deciles(5) & compRS <= deciles(6),1) = 6;
normedRS(compRS > deciles(6) & compRS <= deciles(7),1) = 7;
normedRS(compRS > deciles(7) & compRS <= deciles(8),1) = 8;
normedRS(compRS > deciles(8) & compRS <= deciles(9),1) = 9;
normedRS(compRS >= deciles(9),1) = 10;
RS_deciles = [data.ID, normedRS];

% Plot RS
figure, histogram(normedRS,50); title('Normed Composite RS') % look at your data
figure, histogram(normedRS.^2,50); title('Normed Composite RS Squared') % look at your data squared


%Output results.
%Combined = [Composite_final(:,1), normedRS, normedRS.^2]; % Pairs subject numbers with RS scores. 
%Composite_final_output = array2table(Combined(1:end,:),'VariableNames', {'Subject', 'Composite_Reward', 'Composite_Reward_Squared'});

%name = ('\Composite_Reward.xlsx');
%fileoutput = [output_path, name];
%writetable(Composite_final_output, fileoutput); % Save as csv file
