%% Diana Mainscript 2...this for final model/results only
% assemble_data2;
% %clearvars -except raw_data
% hand_written_vars;

tic 
%takes 30seconds to get the profile re-doing getslopes and stat_testing
%to get params for input to model
MLPba_crossVal;
MLPba_CO2data; %weights are w and v
MLPcb_crossVal; %print cross val error
MLPcb; %weights are ww and vv

%% c to b
%need as input a 9x1 vector of [baro_pres, age, height, weight, restingHR, smoke, freedives, scuba, fitness freq]
user_matrix = survey_data([1,7,13,19,24,29,34,39,44,50,56,61,66,72,78,84,89,95], [3,4,5,6,8,12,13,14,16]);
WHO = 18;%CHANGE HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
BH_ind = 12; %CHANGE HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
user_input = user_matrix(WHO, :)';
%user_input = [988.36;24;179.8;76.4;66.16;0;0;1;1.49]; %resting hr and fitness freq came from my group male avgs
norminput = normalize_patterns(user_input,0);

cb1in = ww * [norminput; 1];%begin forwards pass
cb1out = [1 ./ (1+exp(-cb1in)) ; 1];
cb2in = vv * cb1out;
cb2out = 1 ./ (1+exp(-cb2in));%end of forwards pass

realcb = zeros(size(cb2out)); %begin unnormalizing
tmaxes = [5.2,1.1,170]; %of last inhale, RERs, then timetofirst (bp)
tmins = [0, 0.4,25];
for j = 1:length(tmaxes)
    currrow = cb2out(j,:);
    currmax = tmaxes(j);
    currmin = tmins(j);
    realcb(j,:) = (currrow.*(currmax-currmin)) + currmin;
end

norminput2 = normalize_patterns(realcb,1);
%b to a also need to normalize these guys 
ba1in = w * [norminput2; 1];%begin forwards pass
ba1out = [1 ./ (1+exp(-ba1in)) ; 1];
ba2in = v * ba1out;
ba2out = 1 ./ (1+exp(-ba2in));%end of forwards pass

realba = zeros(size(ba2out)); %begin unnormalizing
tmaxes2 = [10, 0.09, 120]; 
tmins2 = [5.5, 0.01, -0.1881];
for j = 1:length(tmaxes2)
    currrow = cb2out(j,:);
    currmax = tmaxes2(j);
    currmin = tmins2(j);
    realba(j,:) = (currrow.*(currmax-currmin)) + currmin;
end

X2 = realcb(1);
X3 = realcb(2);
X4 = realcb(3);
realcoeffs = [realba(1), realba(2), realba(3)];

% output dive profile
rate = .3;
maxdepth = 10;
bottomtime = 45; %trial_data(BH_ind,12); %this for all the BH lengths that were recorded
extrap_num = 0; %0 means adding to bottom time, anything else means continuing last slope
%stat_testing; %gets mycoeffs, is same everytime
[y1,y2,times,time_error] = diveprofile(rate,maxdepth,bottomtime,realcoeffs,X2,X3,X4,mycoeffs,extrap_num);
set(gcf, 'Color', 'w');
% export_fig('C:/Users/Diana/Documents/MATLAB/thesis_figures/dp_samesubj_diffprof1', '-jpg', '-grey', '-m2');
toc
%going to calculate errors now
dpendCO2 = y1(end);
dpendO2 = y2(end);
recorded_endCO2 = 5.893; %trial_data(BH_ind, 6);
recorded_endO2 = 8.933; %trial_data(BH_ind, 5);
percent_error = [abs(dpendO2-recorded_endO2)/recorded_endO2, abs(dpendCO2-recorded_endCO2)/recorded_endCO2]
with_sign = [dpendO2-recorded_endO2, dpendCO2-recorded_endCO2]





