function [st_endpts] = plotNRB(raw_data, trial_data)
%% Plotting start/end points of BH without rebreathing
close all
myindices = [6,12,18,49,55,71,77,83,94];
subj_list = [103,154,201,411,461,639,661,680,838];
raw_data_nrb = cell(1,length(myindices));
st_endpts = cell(1,length(myindices));

for j = 1:length(myindices)
    raw_data_nrb{j} = raw_data{myindices(j)};
end

for j = 1:length(raw_data_nrb)
    BHnumber = myindices(j);
    if trial_data(BHnumber,23) == 1
        fifty_hund = 50;
    else
        fifty_hund = 100;
    end
    
    c_hyp = raw_data_nrb{j};
    x = c_hyp(:,end);
    y1 = c_hyp(:,1); %oxygen
    y2 = c_hyp(:,2); %carbon dioxide
    
    %for O2
    [~, minloc] = min(y1(1:end-1*fifty_hund));
    endBH = minloc;
    startBH = endBH - (ceil(trial_data(BHnumber,12)+trial_data(BHnumber,24)+1)*fifty_hund+ .5*fifty_hund);
    onlyBH = y1(startBH:endBH);
    times = x(startBH:endBH);
    [endO2, dubdub] = min(onlyBH);
    endO2loc = times(dubdub);
    [startO2, short_loc] = min(onlyBH(1:10*fifty_hund));
    startO2loc = times(short_loc);
    
    %for CO2
    [~, maxloc] = max(y2(1:end-1*fifty_hund));
    endBH2 = maxloc;
    startBH2 = endBH2 - (ceil(trial_data(BHnumber,12)+trial_data(BHnumber,24)+1)*fifty_hund + 0.5*fifty_hund);
    onlyBH2 = y2(startBH2:endBH2);
    times2 = x(startBH2:endBH2);
    [endCO2, dub] = max(onlyBH2);
    endCO2loc = times2(dub);
    [startCO2, short_loc2] = max(onlyBH2(1:10*fifty_hund));
    startCO2loc = times(short_loc2);

    nrb_locs = [startO2loc,endO2loc,startCO2loc,endCO2loc];
    nrb_pts = [startO2,endO2,startCO2,endCO2];
    st_endpts{j} = [nrb_locs;nrb_pts];
    
%     this was to check where my BHs were
%     figure
%     plot(x,y1, 'b-', x,y2,'r-')
%     axis([30, x(end), 0, 23])
%     title(['Subject # ',num2str(subj_list(j)), ' no rebreathing']) 
%     hold on
%     plot(times, onlyBH', 'g') 
%     plot(times2, onlyBH2', 'g')
%     plot(nrb_locs, nrb_pts, 'ko')
end


end