%DA Exprerimental Data Analysis
%plotting all 5 rebreathing BH's O2 on same plot, CO2 on different plot

close all
%% load raw data from my experiments
%assemble_data2; 
%reformat raw_data so that it only includes 5 rebreathing trials, same
%subject order, doing this manually
myindices = [1:5,7:11,13:17,19:48,50:54,56:70,72:76,78:82,84:93]; %leaving out last 4, from experienced BHD
ind_hyps = [5,11,17,23,28,33,38,43,48,54,60,65,70,76,82,88,93];
subj_list = [103,154,201,254,267,295,305,370,411,461,479,527,639,661,680,749,838];
raw_data_rebreathing = cell(1,length(myindices));
raw_data_hv = cell(1,length(ind_hyps));
for j = 1:length(myindices)
    raw_data_rebreathing{j} = raw_data{myindices(j)};
end
for j = 1:length(ind_hyps)
    raw_data_hv{j} = raw_data{ind_hyps(j)};
end

subj_list_nrb = [103,154,201,411,461,639,661,680,838]; %there's 9 of these...
[st_endpts] = plotNRB(raw_data, trial_data);
%plotting
%outer for loop for each subject, inner for each BH
n = 18; %number of subjects
sub_num = 1;
i=1;
while i < length(raw_data_rebreathing)
    figure    
    for k = 1:5
        BH = zeros(size(raw_data_rebreathing{i}));
        c_subject = raw_data_rebreathing{i};
        x = c_subject(:,end);
        y1 = c_subject(:,1); %oxygen
        y2 = c_subject(:,2); %carbon dioxide
        
        plot(x,y1, 'y-', x,y2,'c-')
        axis([30, x(end), 0, 23])
        legend(['O2', 'CO2']) 
        hold on
        i = i+1;
        if k == 5
            sub_num = sub_num+1;
        end
    end %end of 5 trials
    if trial_data(i,23) == 1
        fifty_hund = 50;
    else
        fifty_hund = 100;
    end
    hold on
    title(['Subject # ',num2str(subj_list((i-1)/5)), ' rebreathing BHs'])
    xlabel(['Time (',num2str(1/fifty_hund), 's)'])
    ylabel('Partial Pressures, kPa')
    legend('O2, CO2');
    truths = ismember(subj_list_nrb, subj_list((i-1)/5));
    if sum(truths) > 0
        Iind = find(subj_list_nrb == subj_list((i-1)/5));
        nrb = st_endpts{Iind};
        nrb_locs = nrb(1,:);
        nrb_pts = nrb(2,:);        
        plot(nrb_locs,nrb_pts, 'ko')
    end  
    %print(['Subject',num2str(subj_list((i-1)/5)),'_AllTrials'], '-dpng');
end

%% plotting hyperventilation trials only
% close all
% for j = 1:length(raw_data_hv)
%     figure
%     c_hyp = raw_data_hv{j};
%     x = c_hyp(:,end);
%     y1 = c_hyp(:,1); %oxygen
%     y2 = c_hyp(:,2); %carbon dioxide
% 
%     plot(x,y1, 'b-', x,y2,'r-')
%     axis([30, x(end), 0, 23])
%     title(['Subject # ',num2str(subj_list(j)), ' pre-BH hyperventilation']) 
% end



