function PCO2 = Dubois_ascentPACO2(pco2,Pvco2,Sbco2,Q,B,vlungs,k,t)

PCO2 = zeros(size(t));
%equation 4 but for descent, assuming metabolism causes neg change in o2
%pressure, but that changing ambient pressure causes increase in PO2,
%changed signs on derivative equation and integrated again, found new
%constant, here's equation for descent

c1 = Pvco2;
c2 = (Sbco2*Q*(B-47))/vlungs;
c3 = c1*c2;
init_c = pco2 - (c3/(k+c2));

for i = 1:length(t)
    firstterm = (init_c*exp((-k*t(i)) - (c2*t(i))));
    secondterm = (c3/(k-c2));
    PCO2(i) = firstterm+secondterm;
end


end