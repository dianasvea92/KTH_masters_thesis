function PO2 = Dash_iterative_PO2fromSat(ShbIN, P50)

%modified hill coefficient from Dash, 2017
%these values from Dash's estimates from table 1
alpha = 2.82;
beta = 1.2;
gamma = 29.25;


% %standard physiological values given in table 1 from Dash
% P50s = 26.8; %mmHg
% PO2s = 100; %mmHg
% PCO2s = 40; %mmHg
% pHps = 7.4;
% pHrbcs = 7.24;
% DPGs = 0.00465; %in molar
% Ts = 37;
% 
% %i need to set these 4 to calculate change from regular:
% pH = 7.24; 
% PCO2 = 40;
% DPG = .00465;
% T = 37;
% 
% %individual changes in P50 due to each factor
% % FOOD FOR THOUGHT: CAN ITERATIVELY VARY THESE OVER TIME TOO, SIMULATE DIVE
% P50h = P50s - (25.535*(pH - pHrbcs)) + 10.646*((pH-pHrbcs)^2) - 1.764*((pH-pHrbcs)^3);
% P50co2 = P50s + 0.1273*(PCO2 - PCO2s) + 0.0001083*((PCO2 - PCO2s)^2);
% P50dpg = P50s + 795.63*(DPG - DPGs) - 19660.89*((DPG - DPGs)^2);
% P50t = P50s + 1.435*(T - Ts) + 0.04163*((T-Ts)^2) + 0.000686*((T-Ts)^3);
% 
% 
% %putting all the individual factors' influences together on P50
% P50 = P50s*(P50h/P50s)*(P50co2/P50s)*(P50dpg/P50s)*(P50t/P50s);


%scheme 1 (fixed point) for calculating PO2 from Sat...
% ShbIN = .5316;
% for i = 1:3
%     PO2 = P50*(((ShbIN/(1-ShbIN)))^(1/nH));
%     nH = alpha-(beta*10^(-(PO2/gamma)));
% end
%should have now a corresponding value of PO2 for my ShbIN, i do, but with
%an error of 15%

%scheme 2
%ShbIN = [0.01:0.01:1];
Pold = P50; %this number was specified by Dash to need to be P50 
PO2 = zeros(size(ShbIN));
tic
for j = 1:length(ShbIN)
    Pold = P50;
    nH = alpha-beta*10^(-(Pold/gamma));
    for i = 1:8
        num = (0.02*Pold)*(hilleq(Pold, P50,nH)-ShbIN(j));
        denom = hilleq((Pold + 0.01*Pold),P50,nH)- hilleq((Pold - 0.01*Pold),P50,nH);
        PO2(j) = Pold - (num/denom);
        nH = alpha-(beta*10^(-(PO2(j)/gamma)));
        Pold = PO2(j);
    end
end
toc
%my calculated PO2 is now accurate to 10e-3, done over the same range as
%the other plots
end


