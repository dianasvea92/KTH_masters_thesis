%time = linspace(0,3,360); %three minutes, two samples p second

sh_frac = 0.04; %shunt fraction (0.04 is 'normal')
AVol = 3; %last inspiratory alveolar volume 
VO2 = 250; %mL o2 consumed per min
bloodVol = 5; %liters blood volume
Hb = 140; %women: 13.8, men: 15.7 g/L
Kh = 0.00134; %huffner constant in L/g
circ_time = 1; %say 1 min for full circulation
Sato = 100;
Pamb = 760;
PO2o = .21*Pamb;
Fao = (713-PO2o)/713; %starting fraction of O2
CO = 6; %cardiac output
b = 0.998; %from farmerly paper
n = 2.937; %hill coefficient from farmerly paper
F50 = 0.0359; %from farmerly paper

time = 0.5;
tic
for i = 1:length(time)
    eqn1term1 = Sato - ((VO2*time(i))/(bloodVol*Hb*Kh));
    eqn2term1 = (CO*Hb*Kh)/(AVol);
    eqn2term2 = (1-sh_frac)/sh_frac;

    f = @(t,x)[ (2/circ_time)*(eqn1term1 + ((AVol*(Fao-x(2)))/(bloodVol*Hb*Kh)) - x(1)) ;
        eqn2term1*eqn2term2*(((b*(x(2)^n))/((x(2)^n) + (F50^n)))-x(1))]; %these are my two simultaneous diff eqs

    [t,xa] = ode45(f, time, [Sato, Fao]);
end
toc


