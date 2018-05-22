clearvars epochs eta alpha hidden survey_data trial_data qualdata quandata patterns targets w v error out
close all
clc
tic
epochs=200; %if too short, we don't have time to see movement
%also, the algorithm doesn't have enough repetitions to reach
%a good weight (separation line)
eta=0.0008; %if too small, many more epochs are needed to reach convergence
alpha=0.05; %scalar factor for improved momentum algorithm
hidden=5;

etavec = [0.001,0.005,0.008,0.01,0.03];
alphavec = [0.1,0.3,0.5,0.7,0.9];
hiddenvec = [5, 10,15,30,60];

hand_written_vars;
% RER ----------------------------------------------------------
%PEco2, PEo2 = vector of samples to be averaged...
PEco2 = trial_data(:,22);
PEo2 = trial_data(:,21);
Pamb = survey_data(:,3);
[RER] = RERcalc(PEco2, Pamb, PEo2);
trial_data = [trial_data, RER]; %now RER's added to each trial
%----------------------------------------------------------------
startnewsubj = [1,7,13,19,24,29,34,39,44,50,56,61,66,72,78,84,89,95]; %mark beginning of new subj
qualdata = survey_data(startnewsubj,:); % now one row for each subject
%cols_int = [2,3,5,6,9,10,11,12,13,17,18,19,20,25,26,27]; %-------CHANGE THIS TO CHOOSE WHICH B'S I WANT TO PREDICT A'S
cols_int = [17,27,13]; %only 3 key params
quandata = trial_data(:,cols_int);
%want to make sure there's no 9999s...replacing each 9999 with the overall average from all subjects collected
for z = 1:length(cols_int)
    currcol = quandata(:,z);
    dummycol = quandata(:,z);
    nines = find(currcol == 9999);
    dummycol(nines) = [];
    curravg = mean(dummycol);
    currcol(nines) = curravg;
    quandata(:,z) = currcol;
end
%--------------------------------------
%train network on all subjects
patterns = quandata'; %is 16x98 rn. each column is one BH, all the rows are all the input variables (say quandata)
toremove = [5,6,11,12,13,14,15,16,17,18,23,24,25,26,27,28,33,38,43,48,49,54,55,60,65,70,71,76,77,82,83,88,93,94]; %removed wonky BHs from CO2 wonkey excel column see column M
BHnumbers = [1:94];
BHnumbers(toremove) = [];
toremove2 = [];
BHnumbers(toremove2) = []; %these from bad logistic fitting equations
input_inds = BHnumbers; %this is BH numbers for all the CO2 BHs (out of 98) I generated model fits for
patterns = patterns(:,input_inds);
sizepat = size(patterns);
%-----------------now want to normalize these inputs, otherwise they're
%always >1 so they're going to return the same value after the sigmoid...
normpatterns = zeros(sizepat);
maxes = [4,1.1,170]; %of last inhale, RERs, then timetofirst (bp)
mins = [0, 0.4,25];
for j = 1:sizepat(1)
    currrow = patterns(j,:);
    currmax = maxes(j);
    currmin = mins(j);
    normpatterns(j,:) = (currrow-currmin)/(currmax-currmin);
end
%------------------------------------------------------------------------

nonlinear_equations;
numcoeffs = 3;
nonlineqn = nonlin_logis; 
startcoeffs = [10,.005, 0.5];
%[slopes, nonlinear_coeffs] = getslopes(O2meas_locs,O2measurements, CO2meas_locs, CO2measurements, numcoeffs, nonlineqn, startcoeffs, trial_data);
targets = nonlinear_coeffs'; %is 89 x 3
targets(:,toremove2) = [];
%try normalizing the targets ----------------------------------
normtargets = zeros(sizepat);
tmaxes = [10, 0.9, 120]; %for the most part rounded these to be close
tmins = [5.5, 0.01, -0.1881];
for j = 1:sizepat(1)
    currrow = targets(j,:);
    currmax = tmaxes(j);
    currmin = tmins(j);
    normtargets(j,:) = (currrow-currmin)/(currmax-currmin);
end
%--------------------------------------------------------------

[w,v,error,out]=backprop_thesis(normpatterns, normtargets, epochs,eta,alpha,hidden);
%targets is a 1xn vector, n is number of BH trials
%patterns is a dxn vector (in 2dim data (like on x/y plot) d=2), so in my case this will be a bigger number
% ------------ want to test now. so running one forwards pass to get one set of coeffs to try in a logistic equation...
% out_raw = zeros(size(out));
% for k = 1:length(maxes)
%     out_raw(k,:) = out(k,:).*maxes(k);
% end
realcoeffs = zeros(size(out));
tmaxes = [10, 0.09, 120]; %for the most part rounded these to be close
tmins = [5.5, 0.01, -0.1881];
for j = 1:sizepat(1)
    currrow = out(j,:);
    currmax = tmaxes(j);
    currmin = tmins(j);
    realcoeffs(j,:) = (currrow.*(currmax-currmin)) + currmin;
end

% figure
% plot(nonlin_logis(realcoeffs(:,20),times))

figure
plot(error)
title("Error from back prop training on normpatterns/normtargets");
xlabel("epochs")
ylabel("Error")
toc