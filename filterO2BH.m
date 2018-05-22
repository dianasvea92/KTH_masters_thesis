function allBH = filterO2BH(BHnumbers, raw_data, trial_data)
% filtering the data, removing all but BH period
%close all

allBH = cell(1,length(BHnumbers));
for k = 1:length(BHnumbers)
    %tic
    BHnumber = BHnumbers(k);
    if trial_data(BHnumber,23) == 1
        fifty_hund = 50;
    else
        fifty_hund = 100;
    end
    currentBH = raw_data{BHnumber};
    currentBHO2 = currentBH(:,1);
    dirtyO2coords2 = find(currentBHO2 <=2 );
    dirtyO2coords = [dirtyO2coords2; find(currentBHO2 >= 25)];
    
    %trying to find avg before or after value to replace any internal clipping with
    if isempty(dirtyO2coords) == 0
        pre_avg = sum(currentBHO2(dirtyO2coords(1):-1:dirtyO2coords(1)-(3*fifty_hund)))/(3*fifty_hund);
        currentBHO2(dirtyO2coords) = pre_avg;
        cleanO2 = currentBHO2;
    else
        cleanO2coords = find(currentBHO2 <=25); 
        cleanO2 = currentBHO2(cleanO2coords);
    end
   
    %first, a moving average to clean up signal, will plot results to compare
    numsecs = 1*150; %need to figure out which are 50samples p sec and which are 100
    mycoeff = ones(numsecs,1)/numsecs;
    avgO2 = filter(mycoeff,1,cleanO2);
    
    %% using lowpass butterworth filter bc it's more intuitive to change cutoff freqs
    %want to see magnitude spectrum of signal 
    O2mags = abs(fft(cleanO2));
    % figure
    % plot(O2mags)
    % xlabel('DFT Bins')
    % ylabel('Magnitude')

    num_bins = length(O2mags);
    % figure
    % plot([0:1/(num_bins/2 -1):1], O2mags(1:num_bins/2))
    % xlabel('normalized freq')
    % ylabel('mag')

    [b,a] = butter(12,0.05,'low');
    H = freqz(b,a,floor(num_bins/2));
    % hold on
    % plot(abs(H))

    filteredO2 = filter(b,a,avgO2);
%      figure
    ffO2 = filter(mycoeff, 1, filteredO2);
    ffO2_short = ffO2(300:end-300);
%      plot(ffO2) %now is nice and smooth, let's try find peaks with min amp

    MPD = 170;
    [PKS, LOCS, W, P] = findpeaks(ffO2_short, 'MinPeakDistance', MPD);
%       hold on
% %      plot(LOCS, PKS, 'r*')
%       plot(cleanO2, 'b.');
%       legend('Filtered O2', 'Cleaned, Original Data')
      

    %now want locations of minimum cleanO2, location of PK before max PK
    [~, endBH] = min(cleanO2(1:end-300));
    [~, maxPKloc] = max(PKS);
    while maxPKloc == 1
        PKS(maxPKloc) = [];
        [~, maxPKloc] = max(PKS);
    end    
    
    %little hardcoded check for some problem datasets
    if sum(ismember([3,34,44],BHnumber)) > 0
        endBH = endBH + 300;
    elseif BHnumber == 56
        endBH = endBH + 200;
    end
    
    startBH = endBH - (ceil(trial_data(BHnumber,12)+trial_data(BHnumber,24)+1)*fifty_hund);
    %little hardcoded check for some datasets that start too late
    if sum(ismember([20,21,26,80,81,87],BHnumber)) > 0
        startBH = startBH - 200;
    end
    
    onlyBH = cleanO2(startBH:endBH);
    timeBH = startBH:1:endBH;
%     hold on
%     plot(timeBH,onlyBH,'g')
%     title(['BH # ',num2str(BHnumber), ' rebreathing trials']) 
%     xlabel('time (0.01 or 0.02s/div)')
%     ylabel('Partial Pressure O2 (kPa)')
    
    [~, minO2loc] = min(onlyBH);
    curBHO2 = onlyBH(1:minO2loc);
    timeBHO2 = timeBH(1:minO2loc);
    
%     hold on
%     plot(timeBHO2,curBHO2,'g')

    allBH{k} = curBHO2;
    %toc
end

end


