%% ITS HISTOGRAM TIMEEEEEEEEE

% TRY USING INTRACLASS CORRELATION HERE close to 1 means high similarity,
% close to 0 means not http://www.statisticshowto.com/intraclass-correlation/

survey_data; %know that each subject's data is in here
startnewsubj = [1,7,13,19,24,29,34,39,44,50,56,61,66,72,78,84,89,95]; %mark beginning of new subj
%, subj#,BH#,Pb,age,cm,kg,(m0/f1),restingHR,food/drink (n0/y1),(0-fat to 3-carbs),caffeine,smoke,freedive,scuba,phys fit,(0(one/two times p week)to 3(more than 6x)),endurance0/HI 1

%% K-means 
%want to append a couple columns or one at a time with the key parameter
%information included that helps define the cluster
%----------------------------------------------------
thebluepill = RERs(1:95); %change this RHS to choose which key parameter i want to cluster with
%----------------------------------------------------
theredpill = survey_data(1:95,3:end);

nans = find(thebluepill == 9999);
thebluepill(nans) = [];
theredpill(nans,:) = [];

theMatrix = [theredpill,thebluepill];

k = 3;
[idx,C, sumd,D] = kmeans(theMatrix,k,'MaxIter', 100,'Replicates', 10, 'Display', 'final');
%idx is 98x1 double with 1s, 2s or 3s (k's) in each position
int_var = thebluepill;

currInd = cell(1,k);
for j = 1:k
    currInd{j} = find(idx == j);
end
%now each cluster has its own cell, in each cell (cluster) exists all the
%BH that were clustered there


means = zeros(1,k);
stdevs = zeros(1,k);
for m = 1:k
    clust = int_var(currInd{m});
    subplot(1,k,m); histogram(clust);
    title(['Cluster ', num2str(m)], 'fontsize', 14)
    means(m) = mean(clust);
    stdevs(m) = std(clust);
    xlabel(['Mu = ', num2str(mean(clust)), ' with StDev = ', num2str(std(clust))], 'fontsize', 14);
    hold on
end
    
means
stdevs

if k == 2
    [TTESTh,TTESTp] = ttest2(int_var(currInd{1}), int_var(currInd{2}),'Alpha',0.05)
end
if k == 3
    ANOVAp = anova1(int_var,idx)
end
%h=0 means we cannot reject the null, doesnt mean they have the same means,
%just that our sample size might not be big enough to detect a difference

set(gcf, 'Color', 'w');
xlabel('Cluster Number', 'fontsize', 18);
ylabel('RER',  'fontsize', 18);
export_fig('C:/Users/Diana/Documents/MATLAB/thesis_figures/ANOVA_RERs', '-jpg', '-grey');
