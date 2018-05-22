function [allBHO2_hyps,O2measurements_hyps, O2meas_locs_hyps, normdPAO2_hyps, normdO2locs_hyps,O2cov_hyps,O2corrcoef_hyps,mycoeffs_hyps,rsq_O2_hyps] = HV_trials_O2_fit(BHhyps,butter_nums,raw_data, trial_data)
%hyperventilation trials
allBHO2_hyps = hyps_filterO2BH(BHhyps, raw_data, trial_data);
[O2measurements_hyps, O2meas_locs_hyps, normdPAO2_hyps, normdO2locs_hyps] = extractingpoints(allBHO2_hyps, BHhyps, trial_data,butter_nums);
[sortedO2meas, O2index] = sort(normdPAO2_hyps(2,:));
sortedO2locs = normdO2locs_hyps(O2index);
O2mat = [sortedO2meas', sortedO2locs'];
O2cov_hyps = cov(O2mat);
[O2corrcoef_hyps, plinear] = corrcoef(O2mat);
[normresid1, mycoeffs_hyps] = mylinearfit(O2mat(:,2), O2mat(:,1));
mycoeffs_hyps;
[rsq_O2_hyps] = rsquared_linear(O2mat(:,1), normresid1);
text = ['Hyp: A linear least squares fit of the PAO2 BH data explains ' num2str(rsq_O2_hyps),'% of its variance with a correlation coefficient of ', num2str(O2corrcoef_hyps(1,2)), '.']
end
