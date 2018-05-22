function [myGLM, mycoeffs, yhat, resids_glm, rsq] = add2var_glm(O2mat_fglm, O2matraw,distrib, link)

y = O2mat_fglm(:,1);
ylog = log(O2mat_fglm(:,1));
O2mat_fglm(:,1) = [];
subplot(3,1,1); histogram(y); %check distribution
title('PAO2 raw data')
subplot(3,1,2); histogram(ylog);
title('Log(PAO2) raw data')
subplot(3,1,3); histogram(1./y);
title('1/PAO2 raw data')

myGLM = fitglm(O2mat_fglm, y, 'Distribution', distrib, 'Link', link);
mycoeffs = myGLM.Coefficients.Estimate;
if strcmp(link, 'identity')
    yhat = mycoeffs(1) + mycoeffs(2).*O2mat_fglm(:,1) + mycoeffs(3).*O2mat_fglm(:,2) + mycoeffs(4).*O2mat_fglm(:,3); %normal distrib, default link
elseif strcmp(link,'log')
    yhat = exp(mycoeffs(1) + mycoeffs(2).*O2mat_fglm(:,1) + mycoeffs(3).*O2mat_fglm(:,2) + mycoeffs(4).*O2mat_fglm(:,3)); %gamma distrib, log link
elseif strcmp(link, 'reciprocal')
    yhat = 1./(mycoeffs(1) + mycoeffs(2).*O2mat_fglm(:,1) + mycoeffs(3).*O2mat_fglm(:,2) + mycoeffs(4).*O2mat_fglm(:,3)); % reciprocal link
end

figure
subplot(2,1,1); plot(O2matraw(:,2),yhat, 'k.')
hold on
plot(O2matraw(:,2), O2matraw(:,1), 'ro')
title('General Linear Model2 PAO2(time, x2, x3)')
xlabel('Time (s)')
ylabel('PAO2 (kPa)')
resids_glm = yhat-O2matraw(:,1);
subplot(2,1,2); plot(resids_glm, 'y.');
title('Residuals')
nnr = norm(resids_glm);
[rsq] = rsquared_linear(O2matraw(:,1), nnr);
figure
histogram(resids_glm)
title('Residuals of GLM')


end