function norminput = normalize_patterns(input,theswitch)

sizepat = size(input);
norminput = zeros(sizepat);
if theswitch == 0
    maxes = [1050,65,200,100,100,1,1,1,4]; %for the most part rounded these to be close
    mins = [990,20,140,50,50,0,0,0,0];
else
    maxes = [4,1.1,170]; %of last inhale, RERs, then timetofirst (bp)
    mins = [0, 0.4,25];
end
for j = 1:sizepat(1)
    currrow = input(j,:);
    currmax = maxes(j);
    currmin = mins(j);
    norminput(j,:) = (currrow-currmin)/(currmax-currmin);
end

end