myfolderinfo = dir('new_excel_files');
sizes = size(myfolderinfo);
raw_data = cell(sizes(2)-2);
tic
for i = 1:sizes(1)-2
    currentname = myfolderinfo(i+2).name;
    current_array = xlsread(currentname);
    raw_data{i} = current_array;
    %note each running of this loop is on average 1 second, there's 98
    %files
end
toc

