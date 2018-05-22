function [BHtime, endPAO2] = Dubois(constants)
%DuBois's model for pp during apnea
close all

%dive profile constants
rate = constants(1);
depth = constants(2);
time_at_depth = constants(3);
B = constants(4);
fO2 = constants(5);
fCO2 = constants(6); 
depthfactor = ((depth + 10)/10);
t_ascent = depth/rate;
t_descent = t_ascent;
P_amb = depthfactor*760; %mmHg atmospheric pressure (say this is ambient pressure acting on fO2 = .21

%physiological constants
Q = constants(7);
CaO2 = constants(8);
CvO2 = constants(9);
AVO2diff = constants(10);
%AVCO2diff = ; %??? what is a standard value for this
vlungs = constants(11);
po2 = constants(12); %starting alveolar PO2 in mmHg
pco2 = constants(13); %starting alveolar PCO2 in mmHg
vo2 = constants(14); %mL per minute resting o2 consumption
VO2 = Q*AVO2diff;
VCO2 = constants(15);
Pvco2 = constants(16);
Sbco2 = constants(17);

%equation 3
k = (VCO2*(B-47))/(vlungs*pco2); %resting conditions, became a constant for DuBois
%FOOD FOR THOUGHT - can I vary this with lung volume, CO2 metabolism, etc?

%equation 4 - DESCENT
R = VCO2/VO2;
t = linspace(0,t_descent,25); %this in seconds
PO2d = Dubois_descentPAO2(pco2,po2,R,k,t);
PCO2d = Dubois_descentPACO2(pco2,Pvco2,Sbco2,Q,B,vlungs,k,t);

%DURING time at depth, no change in ambient pressure
bt = linspace(0,time_at_depth,25);
PO2level = Dubois_levelPAO2(PO2d(length(t)),vo2,vlungs,P_amb,bt);
bottom_t = linspace(t(length(t)),t(length(t))+time_at_depth,25);


%ASCENT with most recent amount of pressure from descent...
po2bottom = PO2level(length(PO2level));
pco2bottom = pco2*3;
at = linspace(0,t_ascent,25);
PO2a = Dubois_ascentPAO2(pco2bottom,po2bottom,R,k,at);
PCO2a = Dubois_ascentPACO2(pco2,Pvco2,Sbco2,Q,B,vlungs,k,at);
endbottom = bottom_t(length(bottom_t));
ascent_t = linspace(endbottom, endbottom+t_ascent, 25);

totaltime = t(length(t))+bt(length(bt))+at(length(at));
tt = linspace(0,totaltime,25);
LOClevel = ones(size(tt))*25;

figure
plot(ascent_t,PO2a,'bo-', t, PO2d, 'ro-',bottom_t,PO2level, 'go-', tt, LOClevel)
legend('Ascent','Descent', 'Bottom')
xlabel(['Time (s) during BH dive at ', num2str(depth),'m with bottom time of ', num2str(time_at_depth), 's'])
ylabel('PO2 in (mmHg)')
title(['PAO2 during BH dive, fixed rate of ascent/descent of ', num2str(rate), 'm/s'])

BHtime = tt(length(tt));
endPAO2 = PO2a(length(PO2a));

end




