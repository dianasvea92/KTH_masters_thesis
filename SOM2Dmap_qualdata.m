%% SOM to display my multidimensional data on 2D grid
%lets do 9 by 9 grid
%want to position all the measured BH quandata on a 9x9 grid, see if secondary dimension
%(from qualdata) influences these "output" numbers (like votes on issues)

% each row in qualdata is a subject
% each column in qualdata is a potential indicator variable, missing
% data accounted for see Methods for prelim report in word docs
clearvars -except raw_data trial_data survey_data
close all
clc

trial_data;
cols_int = [2,3,5,6,9,10,11,12,13,17,18,19,20,25,26,27]; %interesting columns to cluster with
quandata = trial_data(:,cols_int);

for counter = 1:3 %i just do it three times for 3 maps, resetting weights each time
[n_BH,n_preds] = size(quandata);
w=rand([81,n_preds]); %want 16 (bc 4x4 output, one weights row for each node) x n_predictors matrix for weights
nbhd = 10; %with this combo lines nhbd, eta, epochs and leaving the nhbd decrease alone in the loop, about 26% of iterations updates more than one node...then the last 60% updates only winning node?
eta=.1;
epochs=50;
dl=zeros(1,81); %row vector for distances between input vectors and weight vectors (there are 100 weight vectors of length n_preds)
[x,y] = meshgrid(1:9,1:9);
xpos = reshape(x, 1, 81);
ypos = reshape(y, 1, 81);
%abc = linspace(0,-5,epochs);

figure
counter = 0;
for i = 1:epochs
    for j = 1:n_BH %for each subject...each input vector
    p = quandata(j,:); %getting this BH' predictors (each BH has a row of predictors)
    repp = repmat(p,81,1); %repeating this matrix to make it 100 by n_preds
    dl = repp-w; %calculating distance

    [dummy, winner] = min(sum(dl.^2,2)); %winner index of minimum value, summing one row (each column in that row)
    %square to get rid of negative distances...
    pos(j) = winner;
    
    xwin = xpos(winner); %now in xwin, pulling the 1-100 value (which corresponds to spot in output matrix) that the smallest distance occurred at
    ywin = ypos(winner);
    
    newvector = 1:81;
    newUpdates = newvector(sqrt((xpos(newvector)-xwin).^2 + (ypos(newvector)-ywin).^2) <= nbhd);
    if length(newUpdates) > 1
        counter = counter + 1;
    end
    %above line: takes distance from all output nodes to winning node [xpos (1:100) - xwin (the number, ie 37)]
    % anywhere that distance is less than the nbhd, saves the index of that output node in newUpdates
    
    for k = 1:length(newUpdates)
        %updating weights: only rows (output vectors) in the nbhd with
        %prev weight + (eta) * the respective distance to weights
        w(newUpdates(k),:) = w(newUpdates(k),:) + eta.*(dl(newUpdates(k),:)); %remember each row in weights is a diff output node
    end
    
    nbhd = 30/(i+19); %shrinking neighborhood each time
    %would rather use an exponential decay fxn, but just regular with i as time decreases too fast
%     abc2 = abc(i);
%     nbhd = nbhd.*exp(-1/abc2);
    end
    


a = ones(1,81)*n_BH; %a is 81 long, one number for each output node
for ii = 1:length(pos)
    a(pos(ii)) = ii; %a(pos) returns a vector size(pos), where each position in pos has the location of that number in a (example: if a(pos(5)) = 4, then pos(5) = a(4))
end
%pos is the position of the winner for each input vector
%above line puts the number of the input (subj1, subj2, etc) in the position
%of the winning node for that specific subject, rewrites any previous winners,
%so only 100 subjects displayed at one time...
theages; %ages
thebaropressures; %baro_pres
theheights; %heights
theweights; %weights_kg
thegenders; %genders
therestingHrs; %restingHRs
theconsumptions; %consumptions, consumptions2
thecoffees; %caff
therest; %smokes, freedives, scubas, fitness1, fitness2, fitness3
bhordernums = survey_data(:,2); %note red is the 5th bh, or the hyp one, green is nrb, magenta is bh4
p = [bhordernums;0]; %this variable is the one to change for viewing diff variables' influence on outcome
image(p(reshape(a,9,9))+1); %first reshaped a into the 4 by 4 shape
%now in each place in a, there's an subject #
%we're going to take each of those 16 subjects in a, and go one at a
%time, so in the first spot of the 4x4, it's a 350. go into p, and for
%p(350), the number is 0, which corresponds to no party, and a specific
%color code for that pixel/node. then we do p(a(2 (out of 16) ))
end
percentage_changed = counter/(epochs*81)
end