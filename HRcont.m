function [HRs] = HRcont(BHnumbers, raw_data, n, CO2meas_locs, trial_data)
%% lets do heart rate data
close all
%start with sample case
%need to find the imported column from excel that has the pleth data (4th)
HRs = cell(size(BHnumbers));
BHnumber2 = [2
     3
     4
     5
     6
     7
     8
    10
    13
    14
    15
    16
    17
    18
    19
    20
    26
    27
    28
    29
    30
    31
    33
    35
    36
    37
    38
    39
    41
    42
    43
    44
    45
    46
    47
    48
    51
    52
    56
    58
    60]';
for k = 1:length(BHnumbers)
    BHnumber = BHnumbers(k);
    currentBH = raw_data{BHnumber};
    curr_HR = currentBH(:,4);
    beats_sorted = sort(curr_HR);
    beats1 = beats_sorted(1:floor(length(curr_HR)/2));
    beats2 = beats_sorted(floor(length(curr_HR)/2):end);
    mymin = sum(beats1)/length(beats1);
    mymax = sum(beats2)/length(beats2);
    delta = floor((mymax-mymin)/2);
    curr_time = currentBH(:,end); %this is taking the time from the whole trial, need just the BH
    
    BHnumber3 = BHnumber2(k);
    currenttimes = CO2meas_locs{BHnumber3}; %need to convert BHnumber into the index for CO2meas_locs
    %need fifty_hund-----------------------------
    if trial_data(BHnumber,23) == 1
       fifty_hund = 50;
    else
       fifty_hund = 100;
    end
    %--------------------------------------------
    startBH = find(curr_time==currenttimes(1)/fifty_hund);
    endBH = find(curr_time == currenttimes(end)/fifty_hund);
%     BHnumber
%     (endBH-startBH)/fifty_hund
    curr_HR = curr_HR(startBH:endBH);
    curr_time = curr_time(startBH:endBH);

    [maxtab, mintab] = peakdet(curr_HR, delta, curr_time); %holy shit this amazing function

    %find time intervals between each beat
    for_sub = [maxtab(2:end,1)];
    for_sub = [for_sub;0]; %this last value just a dummy to make them same size
    pk2pk = for_sub-maxtab(:,1);
    pk2pk = pk2pk(1:end-1);
    %now have the time intervals between each beat
    HR1 = 60./pk2pk;

    i = 1;
    pk2pk_new = [];
    rate_locs = [];
    while i < length(pk2pk)
        if i < length(pk2pk)-n
            pk2pk_new = [pk2pk_new,sum(pk2pk(i:i+n-1))];
            rate_locs = [rate_locs, maxtab(i+(n/2),1)];
        end
        i = i+n;
    end
    HR2 = (60*n)./pk2pk_new;

%     figure
%     plot(curr_time,curr_HR)
%     hold on
%     plot(maxtab(:,1),maxtab(:,2),'ko')
%     %plot(mintab(:,1),mintab(:,2),'go'), %really only need one (ill stick with max)
%     
%     hold on
%     plot(rate_locs,HR2, 'g')
% 
%     hold on
% %     plot(HR1)
%     title('Plethysmography and Continuous HR each beat')
%     ylabel(['BH number: ', num2str(BHnumber)])
    
    HRs{k} = [rate_locs; HR2];
end


end





