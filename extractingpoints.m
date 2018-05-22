function [O2measurements, O2meas_locs, normdPAO2, normdO2locs, raw_locsO2] = extractingpoints(allBHO2, BHnumbers, trial_data, butter_nums)
% getting the points from each BH
%close all
O2measurements = cell(size(allBHO2));
O2meas_locs = cell(size(allBHO2));
normO2locs_cell = cell(size(allBHO2));
raw_locsO2 = [];
normdPAO2 = [];
normdO2locs = [];
for j = 1:length(BHnumbers)
    %tic

     cur_O2_short = allBHO2{j};
%      figure
%      plot(cur_O2_short)

    if trial_data(BHnumbers(j),23) == 1
       fifty_hund = 50;
    else
       fifty_hund = 100;
    end
    numsecs = 1; %this number of seconds averaging over
    the_smooth = numsecs*fifty_hund; %need to figure out which are 50samples p sec and which are 100
    mycoeff = ones(the_smooth,1)/the_smooth;
    filteredO2 = filter(mycoeff,1,cur_O2_short);
%      hold on
%      plot(filteredO2)
    
    [b,a] = butter(butter_nums(1), butter_nums(2),'low');
    filteredO2_butter = filter(b,a,cur_O2_short);
%      hold on
%      plot(filteredO2_butter, 'g')
%      title('Moving Avg vs LP Butterworth Filter')
%      xlabel(['Time in ',num2str(1/fifty_hund),'s'])
%      ylabel('PAO2 in kPa')
%      legend('Original Data', 'Moving Avg', 'LP filter')
    per_diff = (cur_O2_short-filteredO2)./cur_O2_short;
    thezeros = find(per_diff >=0.1);

    filteredO2(thezeros) = cur_O2_short(thezeros);
%     plot(cur_O2_short)
%     hold on
%     plot(avgO2)
    
%     figure
%     plot(per_diff)
%     title('Percent difference between filtered and original')

    %% finding peaks/valleys time
    %first i want to find the gradient, will accept points where after min
    %number of consecutive neg gradients
    gradO2 = gradient(filteredO2);
    neg_grads = gradO2 < 0; %this now full of 1s and 0s
    decreasingO2 = filteredO2.*neg_grads;
% 
%     figure
%     plot(avgO2)
%     hold on
%     plot(decreasingO2, 'r*')
%     title('Neg Gradients of Avg O2')

    counter = 0;
    thresh = 1*fifty_hund; %so needs to be a second long of neg gradients
    measurements = [];
    locations = [];
    for k = 1:length(decreasingO2)-10
        if decreasingO2(k)>0
            counter = counter+1;
        elseif sum(neg_grads(k:k+10))/10 < 0.7 %if 70% next 10 grads are increasing, can reset counter, otherwise keep going
            counter = 0;
        end

        if counter > thresh
            if k == length(decreasingO2)
                measurements = [measurements,filteredO2(k)];
                locations = [locations,k];
            else
                %only execute here if not going to index past end of vector
                if sum(neg_grads(k:k+10))/10 < 0.9 %if 90% next 10 grads are increasing, otherwise keep going
                    measurements = [measurements,filteredO2(k)];
                    locations = [locations,k];
                    counter = 0;
                end
            end
        end
    end
    %adding the last value
    measurements = [measurements,filteredO2(end)];
    locations = [locations,length(decreasingO2)];

    %need to include a check for that first value (maybe w find peaks?)
    [themin, theminloc] = min(cur_O2_short(1:2*fifty_hund));%also takes min value from first two seconds
    measurements = [themin(1),measurements]; %only using first one found in case there's more than one
    locations = [theminloc(1),locations];
    
    mat1 = [(ones(size(measurements))*BHnumbers(j)); measurements];
    O2measurements{j} = mat1; %O2measurements has the subject number
    O2meas_locs{j} = locations;
    
%     figure
%     plot(cur_O2_short)
%     hold on
%     plot(filteredO2, 'g-')
%     plot(locations,measurements,'r*')
%     title(['BH #',num2str(j),': O2 gas samples for subject #: ', num2str(trial_data(BHnumbers(j),1))])
%     xlabel(['Time in ',num2str(1/fifty_hund),'s'])
%     ylabel('PAO2 in kPa')
    %toc
    
    %next want to normalize each of those to the total BH time
    total_dist = max(O2meas_locs{j}) - min(O2meas_locs{j});
    normO2locs_cell{j} = (O2meas_locs{j} - min(O2meas_locs{j}))/total_dist;
    
    raw_locsO2 = [raw_locsO2, O2meas_locs{j}./fifty_hund];
    normdPAO2 = [normdPAO2,O2measurements{j}];
    normdO2locs = [normdO2locs, normO2locs_cell{j}];
end

figure
plot(normdO2locs, normdPAO2(2,:))
hold on
title('Normalized measurements as % of BH time')
xlabel('% of BH time')
ylabel('PAO2 in kPa')

figure
plot(raw_locsO2, normdPAO2(2,:))
hold on
title('Measurements as fxn of time')
xlabel('BH time')
ylabel('PAO2 in kPa')
end
