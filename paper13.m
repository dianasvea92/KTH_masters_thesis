%paper13
%these subjects breathed diff gas blends by breathing at altitude in
%hypobaric chamber, held their breath as long as possible
PO213 = [36,27;40,31;49,36;61,45;105,47;105,52;105,63;200,72];
PCO213 = [30.5,38; 33.5,43;37,46;37.5,46.5;38,48;38,50.5;38,50.5;38.5,57];
dims = size(PO213);

figure
subplot(1,2,1)
plot([0,1],PO213(1,:));
hold on
for i = 2:dims(1)
plot([0,1],PO213(i,:));
end
xlabel('Start BH and Breakpoint');
ylabel('Partial pressures, (mmHg)');
title('PO2');

subplot(1,2,2)
plot([0,1],PCO213(1,:));
hold on
for i = 2:dims(1)
plot([0,1],PCO213(i,:));
end
xlabel('Start BH and Breakpoint');
ylabel('Partial pressures, (mmHg)');
title('PCO2');

figure
plot(PCO213(1,:),PO213(1,:))
hold on
for i = 2:dims(1)
    plot(PCO213(i,:),PO213(i,:))
end
xlabel('PCO2 Start to End BH');
ylabel('PO2 Start to End BH')
title('Varying initial PO2/PCO2 effects on final PO2/PCO2 after v. apnea')
