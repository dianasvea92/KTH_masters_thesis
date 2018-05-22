function [allBHCO2_hyps,CO2measurements_hyps, CO2meas_locs_hyps, normdPACO2_hyps, normdCO2locs_hyps,CO2corrcoef_hyps,mycoeffsCO2_hyps,rsq_CO2_hyps] = HV_trials_CO2_fit(BHhyps,butter_nums,raw_data, trial_data,nonlin_quad,xo,d)
%hyperventilation trials CO2
allBHCO2_hyps = hyps_filterCO2BH(BHhyps, raw_data, trial_data);
[CO2measurements_hyps, CO2meas_locs_hyps, normdPACO2_hyps, normdCO2locs_hyps] = extractingpointsCO2(allBHCO2_hyps, BHhyps, trial_data,butter_nums);
[sortedCO2meas, CO2index] = sort(normdPACO2_hyps(2,:));
sortedCO2locs = normdCO2locs_hyps(CO2index);
CO2mat = [sortedCO2meas', sortedCO2locs'];
startCO2indices = find(CO2mat(:,2) == 0);
startCO2s = CO2mat(startCO2indices,1);
avg_startCO2 = sum(startCO2s)/length(startCO2s);
[f,resids,J,CovB,MSE] = nlinfit(CO2mat(:,2), CO2mat(:,1), nonlin_quad,xo);
mycoeffsCO2_hyps = f;
times = linspace(min(CO2mat(:,2)),max(CO2mat(:,2)));
figure
subplot(2,1,1), plot(CO2mat(:,2), CO2mat(:,1), 'b-', times, nonlin_quad(f,times), 'y-');
txt1 = ['y = ',num2str(f(1)),'x^2 + ',num2str(f(2)),'x + ', num2str(f(3))]; 
legend('Data', txt1)
title('Pre-BH Hyperventilation PACO2 data and nonlinear fit')
xlabel('% of total BH time')
ylabel('PACO2 in kPa')
subplot(2,1,2), plot(resids, 'y.')
legend(['Norm of residuals = ', num2str(norm(resids))])
title('Residuals')
yhat = nonlin_quad(f,CO2mat(:,2));
[rsq_CO2_hyps, CO2corrcoef_hyps] = rsquared_nonlinear(CO2mat, yhat);
text = ['Hyp: A nonlinear, 2nd order LSR of the PACO2 BH data explains ' num2str(rsq_CO2_hyps),'% of its variance with a correlation coefficient of ', num2str(CO2corrcoef_hyps), '.']
end
