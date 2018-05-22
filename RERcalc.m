function [RER] = RERcalc(PEco2, Pamb, PEo2)

%averaging would be more accurate, but to start will use just the value i pulled from the HD datasheet from excel
%PEco2 = sum(PEco2)/length(PEco2); %averaging a set of values I give
%PEo2 = sum(PEo2)/length(PEo2); %avg
Pamb = 0.1.*Pamb; %converting to kPa from hectoPa
FIo2 = 0.21; %should always be the fraction of O2 unless I breathe diff gases
PIo2 = Pamb*FIo2; %can change the ambient pressure from day to day

num = PEco2*(1-FIo2);
denom = PIo2 - PEo2 - (PEco2.*FIo2);
RER = num./denom;

end