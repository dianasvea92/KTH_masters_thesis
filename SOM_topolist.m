% 3 Topological Ordering of Subjects

subjectsss; %for animal characteristics and names
[nsubj, nchar]=size(props); %gets # of animals and # of characteristics
w=rand([100,nchar]);%create random initial weights between 0 and 1
%why 100 output nodes
epochs=20; 
eta=0.2; %appropriate value according to lab
nbrhd=50; %neighborhood (start) size
out=zeros(1,100); %output nodes - not needed?? only weights of these?
pos=zeros(1,nsubj); %positions of animals for final sorting
d=zeros(100,nchar);
dl=zeros(1,100);

for i=1:epochs
    for j=1:nsubj
        p=props(j,:);
        for k=1:100 %for all output nodes
            d(k,:)=w(k,:)-p; %find the difference between their weight vector and the input (animal characteristics)
            dl(k)=norm(d(k,:)); %calculate the euclidean length of the vector
        end
        [~, winner]=min(dl); %find the winning output node (whose weights are the closest to the input)
        minind=int64(winner-nbrhd); %find the neighborhood node endpoints
            if minind < 1 %make sure the smallest index in the neighborhood is 1 (logically)
                minind=1;
            end
        maxind=int64(winner+nbrhd);
            if maxind > 100 %make sure the largest index in the neighborhood is 100 (logically)
                maxind=100;
            end
        for k=minind:maxind %for all output nodes in the neighborhood of the winner, update their weight vectors, closer to the input
            w(k,:)=w(k,:)+eta*(p-w(k,:));
        end
    end    
    nbrhd=50-i/(epochs-1)*49; %brings nbrhd slowly down to 1 for the last iteration
end 

for l=1:nsubj %finally, see which output node is the winner for each animal
        p=props(l,:); %these rows until pos... are exactly like before, to find winning node
        for k=1:100 
            d(k,:)=w(k,:)-p;
        end
        for m=1:nchar
            dl(m)=norm(d(m,:));
        end
        [~, winner]=min(dl);
        pos(l)=winner; %store the winning node for this animal (input)
end
[~, order]=sort(pos); %sort the winning nodes, so slot 1 instead stores the input index of the animal connected to the first output node, etc...
names(order)' %display the animal names in this order