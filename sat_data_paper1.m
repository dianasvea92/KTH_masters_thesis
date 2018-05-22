%incorporate all saturation raw data from sources in paper 1

winslowSatdata;

PO2RS = [1.02
1.7
10.3
15.4
19.2
22.8
26.6
31.2
36.9
44.5
52
58
74.2
94
193.2];
X3 = PO2RS;

SatRS = [0.6
1
10
20
30
40
50
60
70
80
86.2
90
95
97.2
99.16];
Y3 = SatRS;

PO2S = [1
2
4
6
8
10
12
14
16
18
20
22
24
26
28
30
32
34
36
38
40
42
44
46
48
50
52
54
56
58
60
65
70
75
80
85
90
95
100
110
120
130
140
150
175
200
225
250
300
400
500];
dimsS = size(PO2S);
X4 = PO2S(1:dimsS(1)-5,:);

SatS = [0.6
1.19
2.56
4.37
6.68
9.58
12.96
16.89
21.4
26.5
32.12
37.6
43.14
48.27
53.16
57.54
61.69
65.16
68.63
71.94
74.69
77.29
79.55
81.71
83.52
85.08
86.59
87.7
88.93
89.95
90.85
92.73
94.06
95.1
95.84
96.42
96.88
97.25
97.49
97.91
98.21
98.44
98.62
98.77
99.03
99.2
99.32
99.41
99.53
99.65
99.71];
Y4 = SatS(1:dimsS(1)-5,:);

figure
plot(X2,Y2, 'bo'); hold on; plot(X3,Y3, 'ro'), plot(X4,Y4, 'o');
ylabel('Saturation as Percentage')
xlabel('O2 Partial pressure in mmHg')
title('Dissociation data from 3 papers see Lit Source 1');

%this below was to visualize all of S data without cutting off last bit
%figure 
%plot(PO2S,SatS)

%%
%now going to implement model described in paper 1 and plot it on same
%graph as these three sources of raw data, use it as my conversion from
%continuous sat to continuous PO2

%call iterative function here...


