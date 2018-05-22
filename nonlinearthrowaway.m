%% NONLINEAR (3 places to change things)
CO2pts_BHnum = [];
subjnum = 0;
startCO2s = trial_data(:,25);
for i = 1:length(CO2measurements)
    current_set = CO2measurements{i};
    subjnum = current_set(1,:);
    CO2pts_BHnum = [CO2pts_BHnum, subjnum];
end
CO2pts_BHnum = CO2pts_BHnum';
new_col2 = zeros(size(CO2pts_BHnum));
new_col3 = zeros(size(CO2pts_BHnum));
new_col4 = zeros(size(CO2pts_BHnum));
for k = 1:length(CO2pts_BHnum)
    new_col2(k) = lastinhale(CO2pts_BHnum(k)); %here change RHS of equation to match variable up top
    new_col3(k) = startO2s(CO2pts_BHnum(k));
    new_col4(k) = minSat(CO2pts_BHnum(k));
end
CO2mat_fm = [CO2matraw,new_col4,new_col3];
CO2mat_fm = CO2matraw;
figure
y = CO2mat_fm(:,1);
ylog = log(CO2mat_fm(:,1));
CO2mat_fm(:,1) = [];
subplot(3,1,1); histogram(y); %check distribution
title('PACO2 raw data')
subplot(3,1,2); histogram(ylog);
title('Log(PACO2) raw data')
subplot(3,1,3); histogram(1./y);
title('1/PACO2 raw data')

startCO2indices = find(CO2mat(:,2) == 0);
startCO2s = CO2mat(startCO2indices,1);
avg_startCO2 = sum(startCO2s)/length(startCO2s);
xo = [10,1,avg_startCO2];
xolog = [1, 1, 0, avg_startCO2]; %these work for the log fxn on normalized timeline
xolog2 = [1, 1, 0, avg_startCO2];
xoexp = [2,175,avg_startCO2]; %when x(2) is less than 200, get NaN or Infs...
xologis = [7,1,0];
xologis2 = [11,1,1];
times = linspace(min(CO2matraw(:,2)),max(CO2matraw(:,2)));

%--------------------- NEXT LINE IS THE ONE TO CHANGE-------------------
[myNLM] = fitnlm(CO2mat_fm, y, nonlin_logis,xologis);
myCO2coeffs = myNLM.Coefficients.Estimate;
figure
yhat = nonlin_logis(myCO2coeffs,CO2mat_fm); %----------- ALSO THIS ONE------------------
subplot(3,1,1); plot(CO2matraw(:,2), CO2matraw(:,1), 'b*', CO2matraw(:,2), yhat, 'r.');
txt = ['y = ',num2str(myCO2coeffs(1)),'/(1 + exp(-',num2str(myCO2coeffs(2)),'*(t - ',num2str(myCO2coeffs(3)),'*x2)))'];
legend('Data', txt)
title('PACO2 data and logistic fit')
xlabel('BH time')
ylabel('PACO2 in kPa')
hold on
resids = yhat - CO2matraw(:,1);
subplot(3,1,2); plot(CO2matraw(:,2),resids, 'k*') %basic resids from quadratic
title('Residuals')
subplot(3,1,3); histogram(resids)
title('Residuals')

[rsq_CO2, corrcoef_r] = rsquared_nonlinear(CO2matraw,yhat); 
text = ['This nonlinear fit of the PACO2 BH data explains ' num2str(rsq_CO2),'% of its variance with a correlation coefficient of ', num2str(corrcoef_r), '.']

