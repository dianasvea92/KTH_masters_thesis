%paper12
%note each row is a diff subject's results
%these pressures in kPa
PO212 = [16.9, 30.1, 21, 4.9; 13.8, 30, 13.7, 3.3];
PCO212 = [3, 4.6, 5.7, 5.3; 3.9, 5.8, 5.9, 5.7];
BHtimes = [0, 60,171, 231; 0,60,245,305];

%times are head out immersion, beginning of bottom time, end bottom time,
%at surfacing

%diver info
%[apnea time, depth (m), time at depth, age, height (cm), weight (cm), TLC (L), TLC + buccal pumping]
diverinfo12 = table([231;305], [20;20], [111;185],  [24;30], [190;182], [86;67], [10;8], [13;11.9],'VariableNames', {'ApneaLength', 'Depth', 'TimeatDepth', 'Age', 'Height', 'Weight', 'TLC', 'TLCbuccal'}, 'RowNames', {'D1','D2'})


PO212 = PO212.*7.5; %convert to mmHg
PCO212 = PCO212.*7.5;

figure
plot(BHtimes(1,:),PO212(1,:), 'bo-');
hold on
plot(BHtimes(2,:),PO212(2,:), 'bs-');
plot(BHtimes(1,:), PCO212(1,:),'ro-');
plot(BHtimes(2,:), PCO212(2,:), 'rs-');
xlabel('Time of apnea (s)');
ylabel('Partial pressures, (mmHg)');
title('Two elite apnea divers, apnea for 20msw dive');

    