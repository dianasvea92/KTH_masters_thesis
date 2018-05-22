%% Pearson's linear correlation coeff
close all
[rho, pval] = corr(trial_data);
inds = find(pval < 0.01);
pval2 = pval(inds);
hand_written_vars; %make sure 9999s averaging is turned off before you run this section
%want to see scatter plots
ordersBH = survey_data(:,2);
startCO2s = trial_data(:,25);
startO2s = trial_data(:,26);
RERs = trial_data(:,27);
IVCs = trial_data(:,20);
BHlengths = trial_data(:,12);
lastinhale = trial_data(:,17);
subjnumbers = survey_data(:,1);
endO2s = trial_data(:,5);
endCO2s = trial_data(:,6);
minSat = trial_data(:,10);
timetofirst = trial_data(:,13);
inspPO2 = trial_data(:,2);
inspPCO2 = trial_data(:,3);
resting_PACO2 = trial_data(:,4);
breathingfreq = trial_data(:,9);
preHR = trial_data(:,18);
postHR = trial_data(:,19);
%[slopes, nonlinear_coeffs] = getslopes(O2meas_locs,O2measurements, CO2meas_locs, CO2measurements, numcoeffs, nonlineqn, startcoeffs, trial_data);
slopes_ind = [1:4,7:10,20:22,24:27,29:32,34:37,39:42,44,50:53,56:59,61:64,66:69,72:75,80:81,84:87,89:92];
% minp; %these about HR indicator
%time2min;
HR_ind = [2:4,6:10,12:15,18,20,24,25,27,29:38,45:47,49:52,55,56,58,59,61:63,66:75,77,80,81,83,87,90,92,94,95,97,98]; %these only perfect BHs

%clean it
var1 = lastinhale;
var2 = BHlengths;
% nans3 = find(var2 > 4);
% var1(nans3) = [];
% var2(nans3) = [];
nans = find(var2 == 9999);
var1(nans) = [];
var2(nans) = [];
nans = find(var1 == 9999);
var1(nans) = [];
var2(nans) = [];

figure
scatter(var1,var2, 'b*')
ylabel('BH Length (s)', 'fontsize', 18)
xlabel('Volume of last inhalation (L)', 'fontsize', 18)
[r, p] = corrcoef(var2,var1)
%legend(['p value of correlation: ',num2str(p(1,2))])
% WANT TO FIND CONFIDENCE INTERVAL HERE FOR DIFFERENCE BETWEEN MEANS
set(gcf, 'Color', 'w');
export_fig('C:/Users/Diana/Documents/MATLAB/thesis_figures/ex_scatter2', '-jpg', '-grey');
%% first attempt at running fitglm, model of PAO2 dependent on time and IVC
%make sure hand_written_vars is rerun with the 9999s averaged here
O2matraw; %has time and PAO2 values as points
%----------------------------------------------- this is all for IVC
figure
%want to append a variable column to it to incorporate IVCs (p on BHtime < 0.05)
%need to know which datapoints belong to which subject, O2measurements has this
pts_BHnum = [];

for i = 1:length(O2measurements)
    current_set = O2measurements{i};
    subjnum = current_set(1,:);
    pts_BHnum = [pts_BHnum, subjnum];
end
pts_BHnum = pts_BHnum'; %now is column with all BH_numbers

%remember
%BHnumbers = [1:4,7:10,13:16,20:22,24:27,29:32,34:37,39:42,44,50:53,56:59,61:64,66:69,72:75,80:81,84:87,89:92];
IVCs2 = IVCs(BHnumbers);
new_colIVC = zeros(size(pts_BHnum));
for j = 1:length(pts_BHnum)
    new_colIVC(j) = IVCs(pts_BHnum(j));
end
% -----------------------------------------------------------------------
%this is where i add a new column for that dataset
% pts_BHnum is the key for which BH number the data from trial_data should be placed
new_col2 = zeros(size(pts_BHnum));
new_col3 = zeros(size(pts_BHnum));
new_col4 = zeros(size(pts_BHnum));
for k = 1:length(pts_BHnum)
    new_col2(k) = lastinhale(pts_BHnum(k)); %here change RHS of equation to match variable up top
    new_col3(k) = RERs(pts_BHnum(k));
    new_col4(k) = timetofirst(pts_BHnum(k));
end

O2mat_fglm = [O2matraw, new_col2, new_col3, new_col4];
%now going to remove my data (BH's numbers 13-18)


distrib = 'normal';
link = 'identity'; %default for normal distrib
link2 = 'log'; %default for poisson distrib
link3 = 'reciprocal'; %default for gamma distrib
%[myGLM, mycoeffs, yhat, resids_glm, rsq] = add1var_glm(O2mat_fglm, O2matraw,distrib, link2);
%[myGLM, mycoeffs, yhat, resids_glm, rsq] = add2var_glm(O2mat_fglm, O2matraw,distrib, link2);
[myGLM, mycoeffs, yhat, resids_glm, rsq] = add3var_glm(O2mat_fglm, O2matraw,distrib, link2);
coefCI(myGLM, 0.5); %95% confidence intervals for each coefficient in the model
close all
myGLM

%% testing
% LH = 0.87; 
% STO2 = 16.3;
% RR= trial_data(1,27);
% newtimes = linspace(0,100);
% yhh = exp(mycoeffs(1) + mycoeffs(2).*newtimes + mycoeffs(3)*LH + mycoeffs(4)*STO2 + mycoeffs(5)*RR);
% figure
% plot(newtimes,yhh)
% hold on
% 
% LH = 0.87; 
% STO2 = 16.3;
% RR= trial_data(7,27); %only changed RER
% yhh2 = exp(mycoeffs(1) + mycoeffs(2).*newtimes + mycoeffs(3)*LH + mycoeffs(4)*STO2 + mycoeffs(5)*RR);
% plot(newtimes,yhh2)
% 
% LH = 0.87; 
% STO2 = 15.649;  %only changed STO2
% RR= trial_data(7,27);
% yhh3 = exp(mycoeffs(1) + mycoeffs(2).*newtimes + mycoeffs(3)*LH + mycoeffs(4)*STO2 + mycoeffs(5)*RR);
% plot(newtimes,yhh3)
% 
% LH = 2.72; 
% STO2 = 15.649; %LH alone no influence, but with changing STO2 AND LH, get noticeable difference
% RR= trial_data(1,27);
% yhh4 = exp(mycoeffs(1) + mycoeffs(2).*newtimes + mycoeffs(3)*LH + mycoeffs(4)*STO2 + mycoeffs(5)*RR);
% plot(newtimes,yhh4)
% legend('Baseline', 'Larger RER', 'Lesser startO2', 'Larger inhale')

