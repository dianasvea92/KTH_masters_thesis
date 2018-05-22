nonlin_quad = @(b,xdata)(b(1)*(xdata.^2)) + (b(2).*xdata) + b(3);

nonlin_log = @(b,xdata)b(1).*log10((b(2).*xdata)+b(3)) + b(4);
nonlin_log2 = @(b,xdata)b(1).*log10((b(2).*xdata(:,1))+b(3)) + b(4); %these won't take another variable
nonlin_log3 = @(b,xdata)b(1).*log10((b(2)*xdata + b(3)*xdata + b(4)*xdata)+b(5)) + b(6);

nonlin_exp = @(b,xdata)b(1).*(1-exp(-(b(2)*xdata))) + b(3); %this is shit

nonlin_logis = @(b,xdata)b(1)./(1+ exp(-b(2).*(xdata-b(3))));
nonlin_logis2 = @(b,xdata)b(1)./(1+ exp(-b(2).*(xdata(:,1)-b(3).*xdata(:,2))));
nonlin_logis3 = @(b,xdata)b(1)./(1+ exp(-b(2).*xdata(:,3).*(xdata(:,1)-b(3).*xdata(:,2))));

lin_eqn1 = @(b,xdata)exp((b(1) + b(2).*xdata(:,2)).*xdata(:,1) + b(3).*xdata(:,3) + b(4).*xdata(:,4) + b(5));%making last inhale and time be multiplied