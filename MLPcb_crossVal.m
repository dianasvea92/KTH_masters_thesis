%making cross validation test sets

clearvars epochs eta alpha hidden survey_data trial_data qualdata quandata patterns targets
close all
clc
tic
epochs=5000; %if too short, we don't have time to see movement
%also, the algorithm doesn't have enough repetitions to reach
%a good weight (separation line)
eta=0.0008; %if too small, many more epochs are needed to reach convergence
alpha=0.05; %scalar factor for improved momentum algorithm
hidden=5;
etavec = [0.001,0.005,0.008,0.01,0.03];
alphavec = [0.1,0.3,0.5,0.7,0.9];
hiddenvec = [5, 10,15,30,60];
epochsvector = [9500,9650,9800,10000,10200,10350,10500];

hand_written_vars;
trial_data2 = trial_data;
ss = size(trial_data);
%want to make sure there's no 9999s...replacing each 9999 with the overall average from all subjects collected
for z = 1:ss(2)
    currcol = trial_data2(:,z);
    dummycol = trial_data2(:,z);
    nines = find(currcol == 9999);
    dummycol(nines) = [];
    curravg = mean(dummycol);
    currcol(nines) = curravg;
    trial_data2(:,z) = currcol;
end

cols_int = [17,27,13]; %only 3 key params
quandata = trial_data2(:,cols_int); %now these are the targets

%train network on all subjects
targets = quandata'; %is 16x98 rn. each column is one BH, all the rows are all the input variables (say quandata)
sizetar = size(targets);
%-----------------now want to normalize these inputs, otherwise they're
%always >1 so they're going to return the same value after the sigmoid...
normtargets = zeros(sizetar);
tmaxes = [5.2,1.1,170]; %of last inhale, RERs, then timetofirst (bp)
tmins = [0, 0.4,25];
for j = 1:sizetar(1)
    currrow = targets(j,:);
    currmax = tmaxes(j);
    currmin = tmins(j);
    normtargets(j,:) = (currrow-currmin)/(currmax-currmin);
end
%------------------------------------------------------------------------
survey_matrix = [survey_data(:,3),survey_data(:,4),survey_data(:,5),survey_data(:,6),survey_data(:,8),survey_data(:,12),survey_data(:,13),survey_data(:,14),survey_data(:,16)];
patterns = survey_matrix'; %is 9x98 (with the ')
sizepat = size(patterns);
normpatterns = zeros(sizepat);
%[baro_pres, age, height, weight, restingHR, smoke, freedives, scuba, fitness freq]
pmaxes = [1050,65,200,100,100,1,1,1,4]; %for the most part rounded these to be close
pmins = [990,20,140,50,50,0,0,0,0];
for j = 1:sizepat(1)
    currrow = patterns(j,:);
    currmax = pmaxes(j);
    currmin = pmins(j);
    normpatterns(j,:) = (currrow-currmin)/(currmax-currmin);
end
%--------------------------------------------------------------
%-------------------normpatterns is 9x98 for 98 bhs

randomOrder = randperm(size(normpatterns,2));
newnormpatterns = normpatterns(:,randomOrder);
newnormtargets = normtargets(:,randomOrder); %permute both targets and patterns in same order
%going to create 10 subdata sets
pCVsets = cell(2,10);
tCVsets = cell(2,10); %note its in cell(2,:) where training data lies
counter = 1;
for i = 1:10:100
    if i == 91
        %patterns
        newnormpatterns2 = newnormpatterns; %rewrites new normpatterns to be the full thing again
        pCVsets{1,counter} = newnormpatterns2(:,i:i+7); %the first 10 bh in the random mix
        newnormpatterns2(:,i:i+7) = [];
        pCVsets{2,counter} = newnormpatterns2;
        %targets
        newnormtargets2 = newnormtargets; %rewrites new normpatterns to be the full thing again
        tCVsets{1,counter} = newnormtargets2(:,i:i+7); %the first 10 bh in the random mix
        newnormtargets2(:,i:i+7) = [];
        tCVsets{2,counter} = newnormtargets2;
    else
        %patterns
        newnormpatterns2 = newnormpatterns; %rewrites new normpatterns to be the full thing again
        pCVsets{1,counter} = newnormpatterns2(:,i:i+9); %the first 10 bh in the random mix
        newnormpatterns2(:,i:i+9) = [];
        pCVsets{2,counter} = newnormpatterns2;
        %targets
        newnormtargets2 = newnormtargets; %rewrites new normpatterns to be the full thing again
        tCVsets{1,counter} = newnormtargets2(:,i:i+9); %the first 10 bh in the random mix
        newnormtargets2(:,i:i+9) = [];
        tCVsets{2,counter} = newnormtargets2;
    end
    counter = counter + 1;
end

currError = [];
for j = 1:10
    [ww,vv,errorr,outt, valerrorr]=backprop_thesis_withVal(pCVsets{2,j}, tCVsets{2,j}, epochs,eta,alpha,hidden, pCVsets{1,j}, tCVsets{1,j});
    figure
    plot(errorr, 'r-')
    hold on
    plot(valerrorr, 'b-');
    legend('Training error', 'Validation Error')
    %------rest is for the final cross validation error after all epochs and k-folds
    mysize = size(pCVsets{1,j});
    in1 = ww * [pCVsets{1,j}; ones(1,mysize(2))];%begin forwards pass
    out1 = [1 ./ (1+exp(-in1)) ; ones(1,mysize(2))];
    in2 = vv * out1;
    out2 = 1 ./ (1+exp(-in2));%end of forwards pass
    mydiff = abs(tCVsets{1,j}-out2);
    mycolmean = mean(mydiff,1); %error in all input params averaged, have 10 of these then for each input point
    myavg = mean(mycolmean);
    currError = [currError,myavg];
end
meanCrossVal_Error_cb = mean(currError)

close all