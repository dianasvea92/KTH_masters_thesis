function allBH = filterCO2BH(BHnumbers, raw_data, trial_data)

% filtering the data, removing all but BH period
%close all
%raw_data has all the breath hold trials in it, is 1x98 cell
allBH = cell(1,length(BHnumbers));
for k = 1:length(BHnumbers)
    BHnumber = BHnumbers(k);
    if trial_data(BHnumber,23) == 1
        fifty_hund = 50;
    else
        fifty_hund = 100;
    end
    currentBH = raw_data{BHnumber};
    currentBHCO2 = currentBH(:,2);
    cleanCO2coords = find(currentBHCO2 <=10); %these my vectors to filter
    cleanCO2 = currentBHCO2(cleanCO2coords);
    timeCO2 = length(cleanCO2);
    
    %first, a moving average to clean up signal, will plot results to compare
    numsecs = 1*20; %need to figure out which are 50samples p sec and which are 100
    mycoeff = ones(numsecs,1)/numsecs;
%    avgCO2 = filter(mycoeff,1,cleanCO2);
    
    % using lowpass butterworth filter bc it's more intuitive to change cutoff freqs
    %want to see magnitude spectrum of signal 
    CO2mags = abs(fft(cleanCO2));
%     figure
%     plot(O2mags)
%     xlabel('DFT Bins')
%     ylabel('Magnitude')

    num_bins = length(CO2mags);
%     figure
%     plot([0:1/(num_bins/2 -1):1], O2mags(1:num_bins/2))
%     xlabel('normalized freq')
%     ylabel('mag')

    [b,a] = butter(12,0.05,'low');
    H = freqz(b,a,floor(num_bins/2));
%     hold on
%     plot(abs(H))

    filteredCO2 = filter(b,a,cleanCO2);
%    figure
    %ffCO2 = filter(mycoeff, 1, filteredCO2);
    ffCO2 = filteredCO2;
    ffCO2_short = ffCO2(300:end-300);
%     plot(ffCO2) %now is nice and smooth, let's try find peaks with min amp

    MPD = 400;
    invertedCO2 = max(ffCO2_short)-ffCO2_short;
    [PKS, LOCS] = findpeaks(invertedCO2, 'MinPeakDistance', MPD);
%     hold on
%     plot(LOCS, PKS, 'r*')
%     plot(cleanCO2, 'c.');
    
    %now want locations of minimum cleanCO2, location of PK before max PK
    [endCO2, ~] = max(ffCO2_short);
    endBH = find(ffCO2==endCO2);
    [~, maxPKloc] = max(PKS);
    while maxPKloc == 1
        PKS(maxPKloc) = [];
        [~, maxPKloc] = max(PKS);
    end    

    startBH = endBH - (ceil(trial_data(BHnumber,12)+trial_data(BHnumber,24)+1)*fifty_hund);
    %little hardcoded check for some datasets that start too late
    if sum(ismember([7,9,10,13:15,21,26,39,51,80,81,84,87,90],BHnumber)) > 0
        startBH = startBH - 200;
    end
    
    onlyBH = cleanCO2(startBH:endBH);
    timeBH = startBH:1:endBH;
    
%     hold on
%     plot(timeBH,onlyBH,'g')
%     title(['BH # ',num2str(BHnumber), ' rebreathing trials']) 
%     xlabel('time (0.01 or 0.02s/div)')
%     ylabel('Partial Pressure O2 (kPa)')
    
    [dum, maxCO2loc] = max(onlyBH);
    curBHCO2 = onlyBH(1:maxCO2loc);
    timeBHCO2 = timeBH(1:maxCO2loc);
%     hold on
%     plot(timeBHCO2,curBHCO2, 'g')
%     title(['BH #', num2str(BHnumber), 'CO2'])

    allBH{k} = curBHCO2;
end


end

