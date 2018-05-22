%% Hand_written_vars.m
survey_data = xlsread('HD_data1');
trial_data = xlsread('HD_data2');
trial_data2 = trial_data;
ss = size(trial_data);
%replacing each 9999 with the overall average from all subjects collected
for z = 1:ss(2)
    currcol = trial_data2(:,z);
    dummycol = trial_data2(:,z);
    nines = find(currcol == 9999);
    dummycol(nines) = [];
    curravg = mean(dummycol);
    currcol(nines) = curravg;
    trial_data2(:,z) = currcol;
end
trial_data = trial_data2;
% RER
% PEco2, PEo2 = vector of samples to be averaged...
PEco2 = trial_data(:,22);
PEo2 = trial_data(:,21);
Pamb = survey_data(:,3);
[RER] = RERcalc(PEco2, Pamb, PEo2);
trial_data = [trial_data, RER]; %now RER's added to each trial