function ShbO2 = hilleq(Pold,P50,nH)

%hill equation for saturation
PO2 = Pold;
ShbO2 = ((PO2/P50)^nH)/(1+((PO2/P50)^nH));

end