function PO2 = Dubois_levelPAO2(po2,vo2,vlungs,B,t)

PO2 = zeros(size(t));
%equation 4
for i = 1:length(t)
    PO2consumed_min = ((B-47)*vo2)/vlungs; %remember vo2 is minute volume of O2 consumption
    PO2consumed_sec = PO2consumed_min/60;
    if i ==1
        PO2(i) = po2 - PO2consumed_sec;
    else
        PO2(i) = PO2(i-1) - PO2consumed_sec;
    end
end


end