function [rsq_CO2, corrcoef_r] = rsquared_nonlinear(CO2mat, yhat)

% SStotal = (length(CO2mat(:,1))-1)*var(CO2mat(:,1));
% SSresid = sum(resids.^2);
% n = length(CO2mat(:,1));
% %d = 2; %this the degree of polynomial
% firstterm = SSresid/SStotal;
% secondterm = (n-1)/(n-d-1);
% rsq_CO2 = 1 - (firstterm*secondterm);

% decided not to use above method bc it involves deg of freedom, hard when not a polynomial fit
SST = var(CO2mat(:,1));
SSR = var(yhat);
rsq_CO2 = (SSR/SST);
corrcoef_r = sqrt(rsq_CO2);
end