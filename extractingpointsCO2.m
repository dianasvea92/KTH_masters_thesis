function [CO2measurements, CO2meas_locs, normdPACO2, normdCO2locs, raw_locsCO2] = extractingpointsCO2(allBHCO2, BHnumbers, trial_data, butter_nums)
% getting the points from each BH
%close all
CO2measurements = cell(size(allBHCO2));
CO2meas_locs = cell(size(allBHCO2));
normCO2locs_cell = cell(size(allBHCO2));
raw_locsCO2 = [];
normdPACO2 = [];
normdCO2locs = [];

for j = 1:length(BHnumbers)
    %tic

     cur_CO2_short = allBHCO2{j};
%       figure
%       plot(cur_CO2_short)

    if trial_data(BHnumbers(j),23) == 1
       fifty_hund = 50;
    else
       fifty_hund = 100;
    end
   numsecs = 1; %this number of seconds averaging over
    the_smooth = numsecs*fifty_hund; %need to figure out which are 50samples p sec and which are 100
    mycoeff = ones(the_smooth,1)/the_smooth;
    avgCO2 = filter(mycoeff,1,cur_CO2_short);
%      hold on
%      plot(avgCO2)

    %ended up being best filter here...
    [b,a] = butter(butter_nums(1), butter_nums(2),'low');
    filteredCO2 = filter(b,a,cur_CO2_short);
%     hold on
%     plot(filteredCO2, 'g')
%     title('Moving Avg vs LP Butterworth Filter')
%     xlabel(['Time in ',num2str(1/fifty_hund),'s'])
%     ylabel('PAO2 in kPa')
%     legend('Original Data', 'Moving Avg', 'LP filter')

    per_diff = (cur_CO2_short-filteredCO2)./cur_CO2_short;
    thezeros = find(per_diff >=0.1);

%     plot(cur_CO2_short)
%     hold on
%     plot(filteredCO2)
%     
%     figure
%     plot(per_diff)
%     title('Percent difference between filtered and original')

    %% finding peaks/valleys time
    %first i want to find the gradient, will accept points where after min number of consecutive pos gradients
    gradCO2 = gradient(filteredCO2);
    neg_grads = gradCO2 > 0; %this now full of 1s and 0s
    increasingCO2 = filteredCO2.*neg_grads;

%     figure
%     plot(filteredCO2)
%     hold on
%     plot(increasingCO2, 'r*')
%     title('Neg Gradients of Avg O2')

    counter = 0;
    thresh = 1*fifty_hund; %so needs to be a second long of pos gradients
    measurements = [];
    locations = [];
    for k = 1:length(increasingCO2)
        if increasingCO2(k)>0
            counter = counter+1;
        else
            counter = 0;
        end

        if counter > thresh
            if k == length(increasingCO2)
                measurements = [measurements,filteredCO2(k)];
                locations = [locations,k];
            else
                %only execute here if not going to index past end of vector
                if increasingCO2(k+1) == 0
                    measurements = [measurements,filteredCO2(k)];
                    locations = [locations,k];
                end
            end
        end
    end
    %adding the last value
    measurements = [measurements,filteredCO2(end)];
    locations = [locations,length(increasingCO2)];

    %need to include a check for that first value (maybe w find peaks?)  
    [~, theminloc] = min(cur_CO2_short);%also takes min value from first two seconds
    first_secs = filteredCO2(1:theminloc);
    [PKS, LOCS] = findpeaks(first_secs, 'MinPeakProminence', 0.75);
    if length(PKS) > 1
        first_measureCO2 = PKS(end);
        first_meas_loc = LOCS(end);
    else
        [themax, themaxloc] = max(first_secs);
        first_measureCO2 = themax;
        first_meas_loc = themaxloc;
    end
        
    measurements = [first_measureCO2, measurements]; %only using first one found in case there's more than one
    locations = [first_meas_loc, locations];
    
    %want to make sure i didn't get any extra hyperventilation breaths in there
    %will check this by percent difference to the firstmeasure that i chose with PKS
    meas_diffs = measurements-measurements(1);
    del_locs = find(meas_diffs < 0.55);
    measurements(del_locs(2:end)) = [];
    locations(del_locs(2:end)) = []; 
    
    mat1 = [(ones(size(measurements))*BHnumbers(j)); measurements];
    CO2measurements{j} = mat1; %O2measurements has the subject number
    CO2meas_locs{j} = locations;
%     
%     figure
%     plot(cur_CO2_short)
%     hold on
%     plot(filteredCO2, 'g-')
%     plot(locations,measurements,'r*')
%     title(['BH #',num2str(j),': O2 gas samples for subject #: ', num2str(trial_data(BHnumbers(j),1))])
%     xlabel(['Time in ',num2str(1/fifty_hund),'s'])
%     ylabel('PACO2 in kPa')
    %toc
    
    %next want to normalize each of those to the total BH time
    total_dist = max(CO2meas_locs{j}) - min(CO2meas_locs{j});
    normCO2locs_cell{j} = (CO2meas_locs{j} - min(CO2meas_locs{j}))/total_dist;
    
    raw_locsCO2 = [raw_locsCO2, CO2meas_locs{j}./fifty_hund];
    normdPACO2 = [normdPACO2,CO2measurements{j}];
    normdCO2locs = [normdCO2locs, normCO2locs_cell{j}];
    
end

figure
plot(normdCO2locs, normdPACO2(2,:))
title('Normalized measurements as % of BH time')
xlabel('% of BH time')
ylabel('PACO2 in kPa')

figure
plot(raw_locsCO2, normdPACO2(2,:))
hold on
title('Measurements as fxn of time')
xlabel('BH time')
ylabel('PACO2 in kPa')

end
