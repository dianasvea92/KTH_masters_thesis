function P50 = variable_factors(pH,PCO2,DPG,T)

%standard physiological values given in table 1 from Dash
P50s = 26.8; %mmHg
PCO2s = 40; %mmHg
pHrbcs = 7.24;
DPGs = 0.00465; %in molar
Ts = 37;

%individual changes in P50 due to each factor
% FOOD FOR THOUGHT: CAN ITERATIVELY VARY THESE OVER TIME TOO, SIMULATE DIVE
P50h = P50s - (25.535*(pH - pHrbcs)) + 10.646*((pH-pHrbcs)^2) - 1.764*((pH-pHrbcs)^3);
P50co2 = P50s + 0.1273*(PCO2 - PCO2s) + 0.0001083*((PCO2 - PCO2s)^2);
P50dpg = P50s + 795.63*(DPG - DPGs) - 19660.89*((DPG - DPGs)^2);
P50t = P50s + 1.435*(T - Ts) + 0.04163*((T-Ts)^2) + 0.000686*((T-Ts)^3);


%putting all the individual factors' influences together on P50
P50 = P50s*(P50h/P50s)*(P50co2/P50s)*(P50dpg/P50s)*(P50t/P50s);
end