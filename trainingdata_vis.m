clear all
close all
format short e
%% visualize data in each, will get one graph of apnea (if available) and one table of subject info (if available)
%some visualizations
% paper12;
% paper13;
% winslowSatdata;
% sat_data_paper1;

%% Dash's model
%can calculate a P50 based on different variable body factors
pH = 7.34; %neg correlation
PCO2 = 50; %pos correlation
DPG = .00465; %pos correlation
T = 37; %pos correlation
P50 = variable_factors(pH,PCO2,DPG,T);

% Using model from Dash 2017 to convert Saturation measurements to PO2
sat_data_paper1;

ShbIN = [.9398];
PO2dash = Dash_iterative_PO2fromSat(ShbIN, P50);
Xmodel = PO2dash;
Ymodel = ShbIN.*100;
plot(Xmodel, Ymodel);

%now can use these PO2 numbers from my measurements to try to fit with
%either numerical approaches (ie DuBois) or machine learning

%% testing some data, does it make sense? sure, these untrained divers finished with PO2s b/w 34 and 46mmHg
% paper2;
% minSpO2levels = untraineddiver(:,4)./100;
% PO2dash = Dash_iterative_PO2fromSat(minSpO2levels, P50);

%% Dubois model, constants setting
%dive profile constants
rate = .305; %.305m/s is 1 ft/s, given in Dubois, as standard ascent or descent speed
depth = 0; %in m
time_at_depth = 120; %this in seconds
B = 760; %mmHg, this is standard atmospheric pressure
fO2 = 0.21;
fCO2 = .041; 
constants_diveprofile = [rate, depth, time_at_depth,B,fO2,fCO2];

%physiological constants
Q = 4250; %mL per minute
CaO2 = .2; %rest (is a fraction bc it's per 100mL blood)
CvO2 = .15; %rest
AVO2diff = .083; %with exercise, this can increase up to 16
%AVCO2diff = ; %??? what is a standard value for this
vlungs = 4700; %mL
po2 = 100; %starting alveolar PO2 in mmHg
pco2 = 40; %starting alveolar PCO2 in mmHg
vo2 = 250; %mL per minute resting o2 consumption
VCO2 = 300; %from DuBois
Pvco2 = 60; %mixed venous partial pressure
Sbco2 = .5;

constants_physiological = [Q, CaO2, CvO2, AVO2diff, vlungs,po2,pco2,vo2,VCO2,Pvco2,Sbco2];
ALLconstants = [constants_diveprofile, constants_physiological];
figure
[BHtime, endPAO2] = Dubois(ALLconstants)

%% farmery saturation model
FAO2 = 0; %fraction of alveolar oxygen over time, needs to be as long as sat_data is

