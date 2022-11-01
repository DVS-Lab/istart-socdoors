clear;
close all;
clc;

% Daniel Sazhin
% ISTART Project (UGDG)
% DVS Lab
% 05/13/2022
% Temple University

% Edited by Jimmy for ISTART-socdoors 05/13/2022
% update 10/29/2022

% This code generates a composite reward sensitivity score using BAS and SR
% data. This code also generates a composite substance use score for AUDIT
% and DUDIT.

%% Inputs 

currentdir = pwd;
output_path = currentdir; % Set output path if you would like.

input = 'ISTART-ALL-Combined-042122_SocialDoors.xlsx';
%input = 'istart_covariates_composites_raw_30aug22.xlsx'; % input file  %  
%input = 'istart_covariates_raw_data.xlsx';
data = readtable(input);
Composite_raw = [data.('ID'), data.('BISBAS_BAS'), data.('SPSRWD'), data.('audit_standard_score'), data.('dudit_standard_score')];

%% Jimmy composite test

% Composite substance use score
%AUDIT_raw = [data.audit_standard_score];
%DUDIT_raw = [data.dudit_standard_score];

%mania_raw = [data.score_susd_mania];
%depress_raw = [data.score_susd_depress];

%composite_susd = zscore(mania_raw)+zscore(depress_raw);
%figure, histogram(composite_susd,50); title('Composite SUSD')

%composite_substance = zscore(AUDIT_raw)+zscore(DUDIT_raw);
%composite_audit = zscore(AUDIT_raw);
%figure, histogram(composite_substance,50); title('Substance Use Composite')

% Composite reward sensitivity
BAS_raw = [data.BISBAS_BAS];
SPSRWD_raw = [data.SPSRWD];

compRS = zscore(BAS_raw)+zscore(SPSRWD_raw);
%compRS_square = zeros(length(compRS),2);

figure, histogram(compRS,50); title('Composite');
figure, histogram(compRS.^2,50); title('Composite Squared');

normedRS = zeros(length(compRS),1); % create empty array for storing data
deciles = prctile(compRS,[10 20 30 40 50 60 70 80 90]); % identify deciles

% place linear data into the appropriate deciles
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



%for i=1:length(compRS_square)
%    compRS_square(i,1) = compRS(i,1)*compRS(i,1);
%    compRS_square(i,2) = compRS_square(i,1)-mean(compRS_square(:,1));
%end

%normedRS_square = zeros(length(compRS_square(:,2)),1); % create empty array for storing data
%deciles_square = prctile(compRS_square(:,2),[10 20 30 40 50 60 70 80 90]); % identify deciles

% % place 2nd order data into appropriate deciles
% normedRS_square(compRS_square(:,2) <= deciles_square(1),1) = 1;
% normedRS_square(compRS_square(:,2) > deciles_square(1) & compRS_square(:,2) <= deciles_square(2),1) = 2;
% normedRS_square(compRS_square(:,2) > deciles_square(2) & compRS_square(:,2) <= deciles_square(3),1) = 3;
% normedRS_square(compRS_square(:,2) > deciles_square(3) & compRS_square(:,2) <= deciles_square(4),1) = 4;
% normedRS_square(compRS_square(:,2) > deciles_square(4) & compRS_square(:,2) <= deciles_square(5),1) = 5;
% normedRS_square(compRS_square(:,2) > deciles_square(5) & compRS_square(:,2) <= deciles_square(6),1) = 6;
% normedRS_square(compRS_square(:,2) > deciles_square(6) & compRS_square(:,2) <= deciles_square(7),1) = 7;
% normedRS_square(compRS_square(:,2) > deciles_square(7) & compRS_square(:,2) <= deciles_square(8),1) = 8;
% normedRS_square(compRS_square(:,2) > deciles_square(8) & compRS_square(:,2) <= deciles_square(9),1) = 9;
% normedRS_square(compRS_square(:,2) >= deciles_square(9),1) = 10;
% RS_deciles_square = [data.ID, normedRS_square];

% Plot RS
normedRS = normedRS - mean(normedRS);
figure, histogram(normedRS,50); title('Normed Composite RS') % look at your data
%figure, histogram(compRS,50); title('Composite RS')
%figure, histogram(normedRS_square,50); title('Normed Composite RS Squared') % look at your data squared
figure, histogram(normedRS.^2,50); title('Composite RS_square')

%Output results.
normedRS = normedRS - mean(normedRS);
normedRS_square = normedRS.^2;
normedRS_square = normedRS_square - mean(normedRS_square);
%Combined = [Composite_final(:,1), normedRS, normedRS.^2]; % Pairs subject numbers with RS scores. 
%Composite_final_output = array2table(Combined(1:end,:),'VariableNames', {'Subject', 'Composite_Reward', 'Composite_Reward_Squared'});

%name = ('\Composite_Reward.xlsx');
%fileoutput = [output_path, name];
%writetable(Composite_final_output, fileoutput); % Save as csv file
