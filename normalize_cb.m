function norminput = normalize_cb(input)

sizepat = size(input);
norminput = zeros(sizepat);
pmaxes = [1050,65,200,100,100,1,1,1,4]; %for the most part rounded these to be close
pmins = [990,20,140,50,50,0,0,0,0];
for j = 1:sizepat(1)
    currrow = input(j,:);
    currmax = pmaxes(j);
    currmin = pmins(j);
    norminput(j,:) = (currrow-currmin)/(currmax-currmin);
end

end