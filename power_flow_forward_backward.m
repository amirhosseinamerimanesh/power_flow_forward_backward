clc
clear
close all
%           from    to       r       x
branchdata=[1       2        0.2     0.5
            2       3        0.2     0.5
            2       4        0.2     0.5
            4       5        0.2     0.5
            5       6        0.2     0.5
            5       7        0.2     0.5]
%         bus      P        Q 
loaddata=[3        900      400
          4        900      400
          5        900      400
          6        900      400
          7        900      400]
vs=7200;
numbus=max(loaddata(:,1));
v=zeros(numbus,1);
I_load=zeros(numbus,1);
loadbus=zeros(numbus,1);
ss=size(loaddata(:,1));
s=ss(1);
s_p=zeros(s,1);
b_ex=[numbus+1:numbus+s]

a=[branchdata(:,1);loaddata(:,1)]
b=[branchdata(:,2);b_ex']

S = sparse(a,b,true,numbus+s,numbus+s)
h=view(biograph(S))

for u=1:numbus
    x=['Bus ',num2str(u)]
    set(h.nodes(u),'id',x )
    
end
for u=numbus+1:numbus+s
    x=['Load ',num2str(loaddata(u-numbus,1))]
    set(h.nodes(u),'id',x)
    set(h.nodes(u),'shape','circle')
    set(h.nodes(u),'color',[1 0 0])
end
s_p=loaddata(:,2)+i*loaddata(:,3);
for n=1:s
    loadbus(loaddata(n))=loaddata(n);
    I_load(loaddata(n))=conj((s_p(n)*1000)/7200);
    I_abs=abs(I_load);
    I_angle=rad2deg(angle(I_load));
end
n=0;
I_abs
I_angle
v(2:numbus)=7200;
I_feeder=zeros(numbus,1);
p_loss=0
q_loss=0
for n=1:numbus-1
    m=numbus-n+1;
    h=find(branchdata(:,1)==m);
    hh=branchdata([h],2);
    I_feeder(m)=sum(I_feeder([hh]))+I_load(m);
    abs_I_feeder=abs(I_feeder);
    hj=branchdata(:,2)==m;
    hjj=find(hj==1);
    p_loss=p_loss+((abs_I_feeder(m)^2)*(branchdata(hjj,3)));
    q_loss=q_loss+((abs_I_feeder(m)^2)*(branchdata(hjj,4)));
end
p_loss
q_loss
n=0;
abs_I_feeder=abs(I_feeder)
angle_I_feeder=rad2deg(angle(I_feeder))
% for n=1:numbus
%     P_loss=abs_I_feeder(n)^2*
% end
% nodes= (1:numbus)
% end_nodes=find(~ismember(nodes,branchdata(:,1)))
