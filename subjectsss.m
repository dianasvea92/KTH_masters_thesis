%subjects

subject103 = 1;
subject154 = 2;
subject201 = 3;
subject254 = 4;
subject267 = 5;
subject295 = 6;
subject305 = 7;
subject370 = 8;
subject411 = 9;
subject461 = 10;
subject479 = 11;
subject527 = 12;
subject639 = 13;
subject661 = 14;
subject680 = 15;
subject749 = 16;
subject838 = 17;
subject843 = 18;

names = {'subject103', ...
'subject154', ...
'subject201', ...
'subject254', ...
'subject267', ...
'subject295', ...
'subject305', ...
'subject370', ...
'subject411', ...
'subject461', ...
'subject479', ...
'subject527', ...
'subject639', ...
'subject661', ...
'subject680', ...
'subject749', ...
'subject838', ...
'subject843'};

%% properties

age	= 1; %more than 40 (or equal to...for all the below)
height	= 2; %more than 170
weight	= 3; % more than 70
gender	= 4; %1 is female
restingHR	= 5; % more than 75
food	= 6;
mostlyLip	= 7;
mostlyCarb	= 8;
caffeine	= 9;
smoke	= 10;
freedive	= 11;
scuba	= 12;
physfit	= 13;
trainingfreq = 14; %more than 3x p week
endurance	= 15;
hiit	= 16;

props = zeros(18, 16);

props(subject103, [height, gender, physfit, trainingfreq, endurance, hiit]) = 1;
props(subject154, [age, height, weight, caffeine, freedive, endurance]) = 1;
props(subject201, [gender, scuba, physfit, endurance]) = 1;
props(subject254, [gender, food, mostlyCarb, caffeine, physfit, endurance]) = 1;
props(subject267, [height, weight, food, mostlyCarb, physfit, endurance, hiit]) = 1;
props(subject295, [gender, food, mostlyCarb]) = 1;
props(subject305, [gender, food, mostlyCarb, physfit, endurance]) = 1;
props(subject370, [height, weight, restingHR, food, mostlyCarb]) = 1;
props(subject411, [gender, food, mostlyCarb, caffeine, physfit, endurance]) = 1;
props(subject461, [physfit, endurance]) = 1;
props(subject479, [age, height, gender, restingHR, food, mostlyCarb, caffeine]) = 1;
props(subject527, [gender, restingHR, physfit, endurance]) = 1;
props(subject639, [height, weight, gender,scuba, physfit, endurance]) = 1; 
props(subject661, [height, weight, restingHR, food, mostlyCarb, smoke, freedive, scuba, physfit, endurance, hiit]) = 1;
props(subject680, [height, food, mostlyCarb, caffeine, physfit, endurance]) = 1;
props(subject749, [height, restingHR, food, mostlyCarb, smoke]) = 1;
props(subject838, [age, food, mostlyCarb, caffeine,scuba, physfit, trainingfreq, endurance]) = 1;
props(subject843, [height, food, mostlyCarb, freedive, scuba, physfit, trainingfreq, endurance]) = 1;







