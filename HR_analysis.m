%% HR analysis
close all
%BHnumbers = [2:4,6:10,12:15,18,20,24,25,27,29:38,45:47,49:52,55,56,58,59,61:63,66:75,77,80,81,83,87,90,92,94,95,97,98]; %these only perfect BHs
BHnumbers = [2:4,7:10,20,29:32, 34:37,45:47,50:52,56,58,59,61:63,66:69,72:75,80,81,87,90,92]; %these only perfect BHs
%BHnumbers = [1:98];
%BHnumbers = [1:5];
n = 6;
HRs = HRcont(BHnumbers, raw_data, n, CO2meas_locs, trial_data); %is 1 by 98 cell, each has two rows, top is time, 2nd row is HR
smoothHRs = cell(1,length(BHnumbers));
times = cell(1,length(BHnumbers));
for i = 1:length(BHnumbers)
    currHR = HRs{i};    
    X1 = currHR(1,:);
    Y1 = currHR(2,:);
    XMIN = min(currHR(1,:));
    XMAX = max(currHR(1,:));
    YMIN = min(currHR(2,:));
    YMAX = max(currHR(2,:));
%     plot(currHR(1,:),currHR(2,:))
%     axis([XMIN XMAX YMIN YMAX])
    [mycoeffs] = my5thorderfit(X1, Y1);
    times{i} = linspace(XMIN,XMAX);
    smoothedHR = polyval(mycoeffs, times{i});
    smoothHRs{i} = smoothedHR;
end

%% now can work with smoothHRs...try to find maybe first min? does that time indicate anything?    
%each is a continuous line based on 100 pts from linspace
%close all
minp = zeros(1,length(BHnumbers));
time2min = zeros(1,length(BHnumbers));
percHRdec = zeros(1,length(BHnumbers));
for j = 1:length(BHnumbers)
    currBH = smoothHRs{j};
    currHR = HRs{j};
    currtime = times{j};
    [currMin, minInd] = min(currBH(1:round(0.75*(currBH(1,end))))); %only taking min's in the first 3/4 of BH
    [currMax, maxInd] = max(currBH(1:minInd)); %only taking maxs before the minimum
    DataInv = 1.01*max(currBH) - currBH;
    [Minima,MinIdx2] = findpeaks(DataInv);
    if ~isempty(MinIdx2 > 1) %if it's length>1
        MinMin = max(Minima);
        tempIdx = find(Minima == MinMin);
        MinIdx = MinIdx2(tempIdx);
    end
    minp(j) = MinIdx(1)/100;
    time2min(j) = minp(j)*currtime(end);
    maxp = maxInd/100;
    figure
    plot(currtime, currBH, 'r-', time2min(j), currBH(round(minp(j)*100)), 'ko', maxp*currtime(end), currMax, 'bo')
    percHRdec(j) = (currMax - currBH(round(minp(j)*100)))/currMax;
end

%%
time2min = time2min';
HRlengthBH = trial_data(BHnumbers, 12);
%below pulled from excel, averaged each person's trials together 
time2minavg = [27.0098
   39.9911
   45.9760
   33.0823
  120.2494
   83.4915
   68.6067
  125.7691
   37.7007
   94.5949
   82.0813
   78.8588
   84.4888
   21.6747];
BHlengthsHRavg = [108.3333
  125.7500
   85.0000
  126.5250
  152.7150
  165.0000
  144.3333
  191.9467
   81.0000
  142.0000
  169.5000
  130.0000
  191.0000
  163.0000];
close all
[r, p] = corrcoef(time2minavg,BHlengthsHRavg)

avg_fraction = time2minavg./BHlengthsHRavg;
figure
hist(avg_fraction)
%title('Percentage of BH time to reach minimum Heart Rate', 'fontsize', 14)
xlabel('Time (s) to minimum HR as fraction of total BH length', 'fontsize', 14)
ylabel('Number of BH', 'fontsize', 14)
set(gcf, 'Color', 'w');
%export_fig('C:/Users/Diana/Documents/MATLAB/thesis_figures/HRhist', '-jpg', '-grey');
mymean = sum(avg_fraction)/length(avg_fraction)
mystdev = std(avg_fraction)

%% now have minp and time2min for each of all 98 breathholds
% can see if there was a certain pattern in this that predicts end time

nrbinds1 = [6,12,18,49,55,71,77,83,94];
nrbinds2 = ismember(BHnumbers,nrbinds1);
nrbinds = find(nrbinds2);
nrb_trials_pg = minp(nrbinds);
nrb_trials_rawtime = time2min(nrbinds);

figure
subplot(1,2,1); histogram(minp)
title('Percentage of BH time to Change (decreasing to increasing HR)')
subplot(1,2,2); histogram(time2min)
title('Time (s) to Change (decreasing to increasing HR)')

figure
subplot(1,2,1); histogram(nrb_trials_pg)
title('NRB: Percentage time to indicator')
subplot(1,2,2); histogram(nrb_trials_rawtime)
title('NRB: Time (s) to indicator')

figure
hist(minp)
%title('Percentage of BH time to reach minimum Heart Rate', 'fontsize', 14)
xlabel('Time (s) to minimum HR as fraction of total BH length', 'fontsize', 14)
ylabel('Number of BH', 'fontsize', 14)
set(gcf, 'Color', 'w');
%export_fig('C:/Users/Diana/Documents/MATLAB/thesis_figures/HRind_example', '-jpg', '-grey');
%% want to check if the amplitude of the decrease had anything to do with last inhaled volume

%have time2min as location of the minimum HR, problem is in amplitude
%though, not very accurate smoothing of the curves...

%1. find first max and value at time2min, what percentage is this
percHRdec;

%2. find ratio of lastvolume/IVC
aIVC = trial_data(:,20);
aaIVC = aIVC(BHnumbers);
currcol = aaIVC;
nines = find(aaIVC == 9999);
aaIVC(nines) = [];
curravg = mean(aaIVC);
currcol(nines) = curravg;
bIVC = currcol;

alastinhale = trial_data(:,17);
aalastinhale = alastinhale(BHnumbers);
nines = find(aalastinhale == 9999);
aalastinhale(nines) = [];
curravg = mean(aalastinhale);
currcol(nines) = curravg;
blastinhale = currcol;

lungratio = blastinhale./bIVC;

%3. see if there's any correlation here...
[r, p] = corrcoef(lungratio,percHRdec); %no linear correlation here...there is correlation between last inhale and IVC of the person...
[r,p] = corrcoef(lungratio, time2min); %none here either

