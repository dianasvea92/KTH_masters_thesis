%Dive profiles
figure
conv_factor = 1/101.325; %will convert to atm
%know mycoeffsO2, f_CO2log have the coeffs in them
%can create a 'time' variable split into 3 parts for a hypothetical 'dive'
%----------DIVE PROFILE ------
rate = 0.5; %m/s to get down to max depth
maxdepth = 0; %meters
bottomtime = 138; %seconds

%-------------
times1 = 0:0.2:(maxdepth/rate);
times2 = (maxdepth/rate):0.2:(maxdepth/rate)+bottomtime;
times3 = (maxdepth/rate)+bottomtime:0.2:(2*maxdepth/rate)+bottomtime;
times = [times1,times2,times3];

depths = ones(size(times));
for i = 1:length(times1)
    depths(i) = rate*times(i);
    j = i+length(times1)+length(times2);
    depths(j) = maxdepth-(rate*times(i));
end
for k = 1:length(times2)
    depths(k+length(times1)) = maxdepth;
end

depth_factor = 1+(depths./10);
inds = find(depth_factor==0);
depth_factor(inds) = 1;

% X2 = quandata(27,1); %last inhale (col 17)
% X3 = 16.446; %start PAO2 (col 26)
% X4 = 61.87; %minSat (col 10)
%---------from b (X2, X3, X4) to a
nonlin_logis = @(b,xdata)b(1)./(1+ exp(-b(2).*(xdata-b(3))));
y1 = depth_factor.*nonlin_logis(realcoeffs,times);

%adding O2, SUBJECT 103----------------------
%THIS IS OLD lin_eqn = @(b,xdata)b(1) + b(2).*xdata + b(3).*X2 + b(4).*X3 + b(5).*X4 + b(6).*xdata.*X2 + b(7).*xdata.*X4 + b(8)*X2*X4;
lin_eqn = @(b,xdata)b(1) + b(2).*xdata + b(3).*X2 + b(4).*X3 + b(5).*X4 + b(6).*xdata.*X3 + b(7).*X2.*X3 + b(8).*X2.*X4 + b(9).*X3.*X4;
stat_testing;
mycoeffsO2 = mycoeffs;
y2 = depth_factor.*lin_eqn(mycoeffsO2,times);

plot(times, y1, 'k-');
title(['Gas Profile Subj 103; rate: ', num2str(rate),'m/s, maxdepth: ', num2str(maxdepth), 'm, bottomtime:', num2str(bottomtime),'s']); 
xlabel('Time (s)')
ylabel('Alveolar Partial Pressures (kPa)')
hold on
plot(times,y2, 'b-')
O2danger = ones(size(times)).*4;
plot(times,O2danger,'r--')
legend('PACO2', 'PAO2', 'L.O.C')


