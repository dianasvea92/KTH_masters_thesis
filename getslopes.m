function [slopes, nonlinear_coeffs] = getslopes(O2meas_locs,O2measurements, CO2meas_locs, CO2measurements, numcoeffs, nonlineqn, startcoeffs, trial_data)
%PAO2 slope, rate of decrease PER SUBJECT
%O2meas_locs is 1x62 cell, each cell contains locs for that BH
%O2measurements same size, each cell contains meas for that BH
slopes = zeros(1,length(O2meas_locs));
nonlinear_coeffs = zeros(length(CO2meas_locs),numcoeffs); %number of columns = number of coeffs in that nonlin fit
%b1 is carrying capacity
%b2 is steepness of curve
%b3 is t value where midpoint of sigmoid occurs

for i = 1:length(O2meas_locs)
    %-------------O2
    currmeas = O2measurements{i};
    [~, mycoeffsO2, ~] = mylinearfit(O2meas_locs{i}, currmeas(2,:));
    slopes(i) = mycoeffsO2(1);
    close all
end


toremove = [16,24,25,26,27]; %removed wonky see column M
BHnumbers = [1:94];
BHnumbers(toremove) = [];
for i = 1:length(CO2meas_locs)
   %------------CO2
    currmeasCO2 = CO2measurements{i};
    CO2locsC = CO2meas_locs{i}; %these are in raw numbers, im going to convert them to regular second scale
    if (trial_data(BHnumbers(i),23) == 1)
       fifty_hund = 50;
    else
       fifty_hund = 100;
    end
    CO2locsC = CO2locsC/fifty_hund;
    [myNLM] = fitnlm(CO2locsC, currmeasCO2(2,:), nonlineqn,startcoeffs);
    myCO2coeffs = myNLM.Coefficients.Estimate;
    nonlinear_coeffs(i,:) = myCO2coeffs';
    yhat = nonlineqn(myCO2coeffs',linspace(min(CO2locsC), max(CO2locsC)));
    figure
    plot(CO2locsC, currmeasCO2(2,:), 'r-')
    hold on
    plot(linspace(min(CO2locsC), max(CO2locsC)),yhat, 'b-')
end
%close all
end