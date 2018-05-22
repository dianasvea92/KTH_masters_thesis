function [w]=delta_thesis(patterns, targets, epochs,eta)
%INPUT:
%patterns: training data
%targets: 
%epochs: number of iterations
%eta: steplength
%OUTPUT:
%w: weights

%epochs=100;
%eta=0.001; %steplenght

[insize, ndata] = size(patterns);
[outsize, ndata] = size(targets);

biasrow = ones(1,ndata);
X = [patterns; biasrow];


w = randn(outsize,insize+1);
tic
for i = 1: epochs
        o = w*X;
        delt = targets-o;
        delt = delt>0;
        weightchangetot = eta*(-delt)*X';
        w = w + weightchangetot;

        p = w(1,1:insize); %here i changed a '2' to 'insize'
        k = -w(1, insize+1) / (p*p'); % threshold=-bias and normalized
        l = sqrt(p*p');
    %     plot (patterns(1, find(targets>0)), ...
    %               patterns(2, find(targets>0)), '*', ...
    %               patterns(1, find(targets<0)), ...
    %               patterns(2, find(targets<0)), '+', ...
    %               [p(1), p(1)]*k + [-p(2), p(2)]/l, ...
    %               [p(2), p(2)]*k + [p(1), -p(1)]/l, '-');
    %     drawnow;
    % 
    %     axis ([-2, 2, -2, 2], 'square');
    %     title(sprintf('Epoch: %d', epochs))
end
toc

w = targets/patterns;
end