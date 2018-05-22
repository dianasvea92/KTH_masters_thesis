function [w,v,error,out, valerror]=backprop_thesis_withVal(patterns,targets,epochs,eta, alpha, hidden, patVal, targVal)

[insize, ~] = size(patterns);
[outsize, ndata] = size(targets);

w = randn(1,insize+1);

j=1;
if j < hidden
    while j < hidden
     w = [w; randn(1,insize+1)];
     j=j+1;
    end
end

v = randn(1,hidden+1); %initial randn weights

k=1;
if k < outsize
    while k < outsize
     v = [v; randn(1,hidden+1)];
     k=k+1;
    end
end
error = zeros(1,epochs);
valerror = zeros(1,epochs);


for i=1:epochs
%Step 1: Forwards pass
hin = w * [patterns ; ones(1,ndata)]; %ones(1,ndata) adds biasrow
hout = [1 ./ (1+exp(-hin)) ; ones(1,ndata)]; %non-linear transfer function phi used
oin = v * hout; %sum it for all different h nodes?!
out = 1 ./ (1+exp(-oin));

%[hidden, ndata] = size(hin); % number of nodes in hidden layer


%Step 2: Backward pass
%generalized error signal
delta_o = (out - targets) .* ((1 + out) .* (1 - out)) * 0.5;
delta_h = (v' * delta_o) .* ((1 + hout) .* (1 - hout)) * 0.5;
delta_h = delta_h(1:hidden, :);

%Step 3: Updating weights
if i==1
dw = delta_h * [patterns;ones(1,ndata)]';
dv = delta_o * hout';
end

dw = (dw .* alpha) - (delta_h * [patterns ; ones(1,ndata)]') .* (1-alpha);
dv = (dv .* alpha) - (delta_o * hout') .* (1-alpha);
w = w + dw .* eta;
v = v + dv .* eta;

%calculate training errors
size(patterns,2)/size(patVal,2);
error(i) = sum(sum(abs(out - targets)./2))/(10);

%calculate validation errors, just one forwards pass w current weights
mysize = size(patVal);
in1 = w * [patVal; ones(1,mysize(2))];%begin forwards pass
out1 = [1 ./ (1+exp(-in1)) ; ones(1,mysize(2))];
in2 = v * out1;
Valout = 1 ./ (1+exp(-in2));%end of forwards pass
valerror(i) = sum(sum(abs(Valout - targVal)./2));

end
end