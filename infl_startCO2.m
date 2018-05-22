% Influence of starting PACO2 on breath holds...
BHtimes = trial_data(:,12); %has all the BH info in it
startCO2s = trial_data(:,25);
%1:6, 7:12, 13:18, 19:23, 24:28, 29:33, 34:38,39:43, 44:49, 50:55, 56:60, 61:65, 66:71, 72:77, 78:83, 84:88, 89:94, 95:98
startnewsubj = [1,7,13,19,24,29,34,39,44,50,56,61,66,72,78,84,89,95,99]; %these numbers are indices of BHs that start a new subj
currdiff = [];
i = 1; k = 2;
while i < length(BHtimes)
    group_time = [];
    group_stCO2 = [];
    while i < startnewsubj(k)
        group_time = [group_time, BHtimes(i)];
        group_stCO2 = [group_stCO2, startCO2s(i)];
        i = i+1;
    end
    % step 1: identify longest and shortest BH for each subject.
    % step 2: take the corresponding starting PACO2 values and take the difference between them
    [maxBH, ind] = max(group_time);
    stCO2_1 = group_stCO2(ind);
    [minBH, ind2] = min(group_time);
    stCO2_2 = group_stCO2(ind2);
    currdiff = [currdiff, stCO2_2-stCO2_1];
    k = k+1;
    if k > length(startnewsubj)
        break
    end
end

% currdiff(11) = []; %subj 479     actually increased PCO2 throughout 1-4, increased each time
% currdiff(9) = []; %subj 411       also increased steadily throughout
% currdiff(4) = []; %subj 254      also increased steadily throughout
% step 3: perform t-test to see if this difference is significant (> 0)
[h5,p] = ttest(currdiff,0,'Alpha',0.05) 
[h1] = ttest(currdiff,0,'Alpha',0.01) 
%we reject the null at 5% sig and the data is not normally distributed around 0 w/ uknown variance
%but accept the null at 1%

%% can repeat process with first and fourth BHs, is there a difference there too
orderdiff = [];
i = 1; k = 2;
while i < length(BHtimes)
    group_time = [];
    group_stCO2 = [];
    while i < startnewsubj(k)
        group_time = [group_time, BHtimes(i)];
        group_stCO2 = [group_stCO2, startCO2s(i)];
        i = i+1;
    end
    % step 1: identify longest and shortest BH for each subject.
    % step 2: take the corresponding starting PACO2 values and take the difference between them
    stCO2_1 = group_stCO2(1);
    stCO2_2 = group_stCO2(4);
    orderdiff = [orderdiff, stCO2_1-stCO2_2];
    k = k+1;
    if k > length(startnewsubj)
        break
    end
end
orderdiff = orderdiff(1:end-1); %bc last subject didn't have starting CO2 values
%these ones are the oddballs that pull the average across the 0 distribution
% orderdiff(11) = []; %subj 479     actually increased PCO2 throughout 1-4, increased each time
% orderdiff(9) = []; %subj 411       also increased steadily throughout
% orderdiff(4) = []; %subj 254      also increased steadily throughout
[h5_order,p5_order] = ttest(orderdiff,0,'Alpha',0.05) 
[h1_order] = ttest(orderdiff,0,'Alpha',0.01) 



