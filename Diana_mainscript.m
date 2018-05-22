%% Load data (100 seconds)
assemble_data2;
%clearvars -except raw_data
hand_written_vars; %only 3 seconds from this point down, if assemble_data2 ran

%% Pulling out rebreathing BH measurements (3.5 secs, not including plots)
%raw_data has all the breath hold trials in it, is 1x98 cell
close all
tic
%BHnumbers=[1:4,7:10,13:16,19:22,24:27,29:32,34:37,39:42,44:47,50:53,56:59,61:64,66:69,72:75,78:81,84:87,89:92]; all including wonky ones
BHnumbers = [1:4,7:10,20:22,24:27,29:32,34:37,39:42,44,50:53,56:59,61:64,66:69,72:75,80:81,84:87,89:92]; %removed wonky see column I
allBHO2 = filterO2BH(BHnumbers, raw_data, trial_data);
butter_nums = [12,0.08]; %decent, butclose all too  much lag, going to go with the moving avg
%------------BEFORE YOU RUN NEXT LINE MAKE SURE YOU HAVE MOVING AVG NOT BUTTER INEXTRACTINGPOINTS.M---------------------------------
[O2measurements, O2meas_locs, normdPAO2, normdO2locs, raw_locsO2] = extractingpoints(allBHO2, BHnumbers, trial_data, butter_nums);

% pulling out CO2 BHs
toremove = [5,6,11,12,13,14,15,16,17,18,23,24,25,26,27,28,33,38,43,48,49,54,55,60,65,70,71,76,77,82,83,88,93,94]; %removed wonky see column M
BHnumbers = [1:94];
BHnumbers(toremove) = [];

allBHCO2 = filterCO2BH(BHnumbers, raw_data, trial_data);
butter_nums = [2,0.08];
[CO2measurements, CO2meas_locs, normdPACO2, normdCO2locs, raw_locsCO2] = extractingpointsCO2(allBHCO2, BHnumbers, trial_data, butter_nums);
toc

%% Fitting measures
[sortedO2meas, O2index] = sort(normdPAO2(2,:));
sortedO2locs = normdO2locs(O2index);
sortedO2rawlocs = raw_locsO2(O2index);
[sortedCO2meas, CO2index] = sort(normdPACO2(2,:));
sortedCO2locs = normdCO2locs(CO2index);
sortedCO2rawlocs = raw_locsCO2(CO2index);

O2mat = [sortedO2meas', sortedO2locs']; %normalized
O2matraw = [sortedO2meas', sortedO2rawlocs'];
CO2mat = [sortedCO2meas', sortedCO2locs']; %normalized
CO2matraw = [sortedCO2meas', sortedCO2rawlocs'];

%% LINEAR
%below is all O2
O2cov = cov(O2matraw);
[O2corrcoef, plinear] = corrcoef(O2matraw);
%next line performs linear fit and saves normresid so i can calculate r squared
[normresid1, mycoeffsO2, rsq_O2,MYresids] = mylinearfit(O2matraw(:,2), O2matraw(:,1));
%set(gcf, 'Color', 'w');
%export_fig('C:/Users/Diana/Documents/MATLAB/thesis_figures/O2modelV1', '-jpg', '-grey');

text = ['A linear least squares fit of the PAO2 BH data explains ' num2str(rsq_O2),'% of its variance with a correlation coefficient of ', num2str(O2corrcoef(1,2)), '.']
figure
histogram(MYresids);
title('Residuals from Linear Model on Raw Data', 'fontsize', 14)
xlabel('PAO2 (kPa)', 'fontsize', 14)
set(gcf, 'Color', 'w');
export_fig('C:/Users/Diana/Documents/MATLAB/thesis_figures/O2modelV1', '-jpg', '-grey');
% %below is all CO2 - lol CO2 not a good data set for linear fit
% CO2cov = cov(CO2mat);
% CO2corrcoef = corrcoef(CO2mat);
% %next line performs linear fit and saves normresid so i can calculate r squared
% [normresid2, mycoeffs2] = mylinearfit(CO2mat(:,2), CO2mat(:,1));
% [rsq_CO2] = rsquared_linear(CO2mat, normresid2);
% text = ['A linear least squares fit of the PACO2 BH data explains ' num2str(rsq_CO2),'% of its variance with a correlation coefficient of ', num2str(CO2corrcoef(1,2)), '.']
lin_eqn = @(x,xdata)(x(1)*(xdata)) + x(2); 
%% NONLINEAR
nonlin_quad = @(x,xdata)(x(1)*(xdata.^2)) + (x(2)*xdata) + x(3); %where x is my coeffs and xdata is PACO2
nonlin_log = @(x,xdata)x(1).*log10((x(2)*xdata)+x(3)) + x(4);
nonlin_exp = @(x,xdata)x(1).*(1-exp(-(x(2)*xdata))) + x(3);
nonlin_logistics = @(x,xdata)x(1)./(1+x(2).*exp(-x(3).*xdata));

startCO2indices = find(CO2mat(:,2) == 0);
startCO2s = CO2mat(startCO2indices,1);
avg_startCO2 = sum(startCO2s)/length(startCO2s);
xo = [10,1,avg_startCO2];
xolog = [1, 1, 0, avg_startCO2]; %these work for the log fxn on normalized timeline
xoexp = [2,175,avg_startCO2]; %when x(2) is less than 200, get NaN or Infs...
xologis = [10,(10/avg_startCO2)-1,1];

[f_CO2,resids,J,CovB,MSE] = nlinfit(CO2matraw(:,2), CO2matraw(:,1), nonlin_quad,xo);
[f_CO2log,residslog,Jlog,CovBlog,MSElog] = nlinfit(CO2matraw(:,2)+.000001, CO2matraw(:,1), nonlin_log,xolog); %CO2mat(:,2) is all locs, (:,1 is measures)
[f_CO2exp,residsexp,Jexp,CovBexp,MSEexp] = nlinfit(CO2matraw(:,2), CO2matraw(:,1), nonlin_exp,xoexp); %CO2mat(:,2) is all locs, (:,1 is measures)
[f_CO2logis, resids_logis, Jlogis, CovBlogis, MSElogis] = nlinfit(CO2matraw(:,2), CO2matraw(:,1), nonlin_logistics,xologis);

%CO2mat = CO2matraw; %can comment this out if i want the normalized version
times = linspace(min(CO2mat(:,2)),max(CO2mat(:,2)));
% figure
% subplot(2,1,1); plot(CO2mat(:,2), CO2mat(:,1), 'b.', times, nonlin_quad(f_CO2,times), 'r-'); %basic quadratic
% txt_quad = ['y = ',num2str(f_CO2(1)),'x^2 + ',num2str(f_CO2(2)),'x + ', num2str(f_CO2(3))]; 
% legend('Data', txt_quad)
% title('PACO2 data and quadratic fit')
% xlabel('% of total BH time')
% ylabel('PACO2 in kPa')
% hold on
% subplot(2,1,2); plot(resids, 'r*') %basic resids from quadratic
% title('Residuals')


times_raw = linspace(min(CO2matraw(:,2)),max(CO2matraw(:,2)));
figure
subplot(2,1,1); plot(CO2matraw(:,2), CO2matraw(:,1), 'b.', times_raw, nonlin_logistics(f_CO2logis,times_raw), 'k-'); %plotting logistics
txt_log = ['y = ',num2str(f_CO2log(1)),'*log(',num2str(f_CO2log(2)),'x + ', num2str(f_CO2log(3)),') +',num2str(f_CO2log(4))]; 
txt_exp = ['y = ',num2str(f_CO2exp(1)),'*(1-exp(-',num2str(f_CO2exp(2)),'x)) + ',num2str(f_CO2exp(3))];
txt_logis = ['y = ',num2str(f_CO2logis(1)),'/(1 + ',num2str(f_CO2logis(2)),'*exp(-',num2str(f_CO2logis(3)),'*x)'];
%legend('Data', txt_log)
%title('PACO2 data with Logistic Growth Fit', 'fontsize', 14)
xlabel('BH time (s)', 'fontsize', 14)
ylabel('PACO2 (kPa)', 'fontsize', 14)
hold on
subplot(2,1,2); histogram(resids_logis) %plotting resids of diff kinds of nonlinear fits
xlabel('Residuals', 'fontsize', 14)
ylabel('Count', 'fontsize', 14)
dlog = 1; %depends on what order polynomial im fitting with
yhat = nonlin_quad(f_CO2, CO2matraw(:,2));
yhatlogis = nonlin_logistics(f_CO2logis, CO2matraw(:,2));

[rsq_CO2, corrcoef_r] = rsquared_nonlinear(CO2matraw, yhat); %raw data
[rsq_CO2logis, corrcoef_rlogis] = rsquared_nonlinear(CO2matraw, yhatlogis); %raw data
text = ['A nonlinear, 2nd order LSR of the PACO2 BH data explains ' num2str(rsq_CO2),'% of its variance with a correlation coefficient of ', num2str(corrcoef_r), '.']
text = ['A nonlinear, logistics growth curve of the PACO2 BH data explains ' num2str(rsq_CO2logis),'% of its variance with a correlation coefficient of ', num2str(corrcoef_rlogis), '.']
set(gcf, 'Color', 'w');
% export_fig('C:/Users/Diana/Documents/MATLAB/thesis_figures/CO2modelV1', '-jpg', '-grey');

%% Hyperventilation trials
%O2
%BHhyps = [5,11,17,23,28,33,38,43,48,54,60,65,70,76,82,88,93]; %all every one BH
BHhyps = [5,11,17,28,33,38,43,48,54,60,70,76,82,88,93]; %removed some weird looking or super noisy datasets
butter_nums = [2, 0.03]; %went through pt selection, looks ok, some extras in there, maybe 2 sets missing 2 or 3 pts each
%------------BEFORE YOU RUN NEXT LINE MAKE SURE YOU BUTTER NOT MOVING AVG IN EXTRACTINGPOINTS.M---------------------------------
[allBHO2_hyps,O2measurements_hyps, O2meas_locs_hyps, normdPAO2_hyps, normdO2locs_hyps,O2cov_hyps,O2corrcoef_hyps,mycoeffs_hyps,rsq_O2_hyps] = HV_trials_O2_fit(BHhyps,butter_nums,raw_data, trial_data);
%CO2
butter_nums = [2,0.08];
nonlin_quad = @(x,xdata)(x(1)*(xdata.^2)) + (x(2)*xdata) + x(3);
d = 2;
xo = [0,0,avg_startCO2]; %this when t = 0, solves quad eqn for avg of all CO2 starting pts, converges anyway
[allBHCO2_hyps,CO2measurements_hyps, CO2meas_locs_hyps, normdPACO2_hyps, normdCO2locs_hyps,CO2corrcoef_hyps,mycoeffsCO2_hyps,rsq_CO2_hyps] = HV_trials_CO2_fit(BHhyps,butter_nums,raw_data, trial_data,nonlin_quad,xo,d);

[bhVo2, VO2hypdiff] = extraVO2fromhyps(survey_data, trial_data);

%% Regular BH trials
% not trying to fit anything here, since no description of what's going on during BH, only start and end points,
% but might be helpful to visualize start/end points on same plot as all the rebreathing ones
%O2CO2_allBHeachsubj %------------------------------------------
%[st_endpts] = plotNRB(raw_data, trial_data); %-----------------can plug these locs into my model, see the predicted error
% when compared to the actual values (remember first row is locs, 2nd is value

%% outputting dive profiles
%diveprofile_test;

%% visualize each fit line for each BH
%need to specify bottom three things for the PACO2 fits
nonlinear_equations;
numcoeffs = 3;
nonlineqn = nonlin_logis; 
startcoeffs = [10,.005, 0.5];
[slopes, nonlinear_coeffs] = getslopes(O2meas_locs,O2measurements, CO2meas_locs, CO2measurements, numcoeffs, nonlineqn, startcoeffs, trial_data);
% check HR, also bc need it in stat_testing later    
HR_analysis;
%% updating models
stat_testing;
nonlinearthrowaway; 


