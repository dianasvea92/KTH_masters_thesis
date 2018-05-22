function PO2 = Dubois_ascentPAO2(pco2,po2,R,k,t)

PO2 = zeros(size(t));
%equation 4
for i = 1:length(t)
    PO2(i) = (((pco2/R)+po2)*(exp(-k*(t(i)/60)))) -(pco2/R);
end


end