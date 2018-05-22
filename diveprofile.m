function [y1,y2,times,time_error] = diveprofile(rate,maxdepth,bottomtime,realcoeffs,X2,X3,X4,mycoeffs,extrap_num)
%Dive profiles
figure
conv_factor = 1/101.325; %will convert to atm
%know mycoeffsO2, f_CO2log have the coeffs in them
%can create a 'time' variable split into 3 parts for a hypothetical 'dive'
%-------------
times1 = 0:0.2:(maxdepth/rate);
times2 = (maxdepth/rate):0.2:(maxdepth/rate)+bottomtime;
%newrate = .667;
times3 = (maxdepth/rate)+bottomtime:0.2:(2*maxdepth/rate)+bottomtime;
times = [times1,times2,times3];

depths = ones(size(times));
for i = 1:length(times1)
    depths(i) = rate*times(i);
    j = i+length(times1)+length(times2);
    depths(j) = maxdepth-(rate*times(i));
end
% newvec = linspace(maxdepth,0,200);
% depths([203:402]) = newvec;
for k = 1:length(times2)
    depths(k+length(times1)) = maxdepth;
end

depth_factor = 1+(depths./10);
inds = find(depth_factor==0);
depth_factor(inds) = 1;

%need to rewrite depth_factor and times3

%---------from b (X2, X3, X4) to a
nonlin_logis = @(b,xdata)b(1)./(1+ exp(-b(2).*(xdata-b(3))));
y1 = depth_factor.*nonlin_logis(realcoeffs,times);

%adding O2, SUBJECT 103----------------------
%THIS IS OLD lin_eqn = @(b,xdata)b(1) + b(2).*xdata + b(3).*X2 + b(4).*X3 + b(5).*X4 + b(6).*xdata.*X2 + b(7).*xdata.*X4 + b(8)*X2*X4;
lin_eqn = @(b,xdata)b(1) + b(2).*xdata + b(3).*X2 + b(4).*X3 + b(5).*X4 + b(6).*xdata.*X3 + b(7).*X2.*X3 + b(8).*X2.*X4 + b(9).*X3.*X4;
%stat_testing;
mycoeffsO2 = mycoeffs;
y2 = depth_factor.*lin_eqn(mycoeffsO2,times);

plot(times, y1, 'k-');
%title(['Gas Profile Subj 103; rate: ', num2str(rate),'m/s, maxdepth: ', num2str(maxdepth), 'm, bottomtime:', num2str(bottomtime),'s']); 
xlabel('Time (s)', 'fontsize', 14)
ylabel('Alveolar Partial Pressures (kPa)', 'fontsize', 14)
hold on
plot(times,y2, 'k-.')
O2danger = ones(size(times)).*4;
plot(times,O2danger,'r--')


xx = [times(end),times(end)];
yy = [y2(end),y1(end)];
err = [0.1332*yy(1)*2 , 0.1318*yy(2)*2];
errorbar(xx,yy,err)
%legend('PACO2', 'PAO2', 'L.O.C')

% %now going to go back and add the extrapolation to the profile for a time window
% times2 = (maxdepth/rate):0.2:(maxdepth/rate)+bottomtime;
% counter = 0;
% y2ex = y2(end);
% i =0;
% times4 = [];
% diff=5;
% while diff > 5
%     %just adding to bottom time...that's where the time error can be
%     %------------------------------------------
%     if extrap_num == 0
%         counter = counter + 0.2;
%         bottomtime = bottomtime + counter;
%         times2 = (maxdepth/rate):0.2:(maxdepth/rate)+bottomtime;
%         times3 = (maxdepth/rate)+bottomtime:0.2:(2*maxdepth/rate)+bottomtime;
%         times4 = [times1,times2,times3];
%         depths = ones(size(times4));
%         for i = 1:length(times1)
%             depths(i) = rate*times4(i);
%             j = i+length(times1)+length(times2);
%             depths(j) = maxdepth-(rate*times4(i));
%         end
%         for k = 1:length(times2)
%             depths(k+length(times1)) = maxdepth;
%         end
%         depth_factor = 1+(depths./10);
%         inds = find(depth_factor==0);
%         depth_factor(inds) = 1;
%         y1ex = depth_factor.*nonlin_logis(realcoeffs,times4);
%         y2ex = depth_factor.*lin_eqn(mycoeffsO2,times4);
%         diff = y2ex(end) - 0.1332*y2ex(end);
%         if diff <= 4
%             hold on
%             plot(times4, y2ex, 'k-.');
%             err_ex = 0.1332*y2ex(end)*2;
%             hold on
%             errorbar(times4(end),y2ex(end),err_ex);
%             hold on
%             O2danger2 = 5.*ones(size(times4));
%             plot(times4,O2danger2,'r--');
%         end
%         set(gca,'XLim',[0 times4(end) + 5])
%     else
%     %------------------------------------------ now continuing other curve
%         counter = counter + 0.2;
%         last_slope = y2(end-2) - y2(end-1);
%         times4 = times(end) + counter; %times4 is just one value now
%         y2ex = y2ex(end)-last_slope;
%         diff = y2ex(end) - 0.1332*y2ex(end);
%         if diff <= 4
%             hold on
%             plot([times(end), times4], [y2(end),y2ex], 'k-.');
%             err_ex = 0.1332*y2ex(end)*2;
%             hold on
%             errorbar(times4(end),y2ex(end),err_ex);
%             hold on
%             O2danger2 = 5.*ones(size(times4));
%             plot([times(end),times4],[O2danger(end),O2danger2],'r--');
%         end
%         set(gca,'XLim',[0 times4(end) + 5])
%     %----------------------------------------------------
%     end
% end
% 
% time_error = times4(end)-times(end)
time_error = 0;
    
end
