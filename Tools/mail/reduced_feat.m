function [group1] = reduced_feat(t1)
nt1=t1; 
%l1=length(nt1);
% l2=length(nt2);
% z=l1-l2;
% group1=[nt2 zeros(1,(z))];
% group1(2:61,1:l1)= nt1;
m=1; n=1;
while n<56
group1(m,:)=t1(n,:);
m=m+1;
n=n+3;
end