%DA Exprerimental Data Analysis
%plotting each BH's O2 and CO2 on same plot

%% load raw data from my experiments
%assemble_data2.m; did this already today

%for example, let's start only with the first subject, from excel key i
%know they have 6 BH
BH = zeros(size(raw_data{1}));
close all
for i = 1:6
    BH = zeros(size(raw_data{i}));
    c_subject = raw_data{i};
    x = c_subject(:,6);
    y1 = c_subject(:,1); %oxygen
    y2 = c_subject(:,2); %carbon dioxide
    figure
    plot(x,y1, 'b-', x,y2,'r-')
    axis([30, x(end), 0, 23])
    title(['Subject 1 BH # ',num2str(i)]) 
end





