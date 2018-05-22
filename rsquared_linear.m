function [rsq_O2] = rsquared_linear(orig_data, normresid1)
% Purpose: compute R2
% new variables we just saved from performing basic fit: fitX, normresidX, and residsX

% 1. compute total sum of squares
SSO2 = (length(orig_data)-1)*var(orig_data);
rsq_O2 = 1 - normresid1^2/SSO2;
end