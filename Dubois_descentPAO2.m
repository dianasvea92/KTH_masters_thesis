function PO2 = Dubois_descentPAO2(pco2,po2,R,k,t)

PO2 = zeros(size(t));
%equation 4 but for descent, assuming metabolism causes neg change in o2
%pressure, but that changing ambient pressure causes increase in PO2,
%changed signs on derivative equation and integrated again, found new
%constant, here's equation for descent

for i = 1:length(t)
    PO2(i) = ((po2-(pco2/R))*(exp(k*(t(i)/60)))) + (pco2/R);
end

% %assuming no metabolism
% for i = 1:length(t)
%     PO2(i) = po2*(exp(k*(t(i)/60)));
% end

end