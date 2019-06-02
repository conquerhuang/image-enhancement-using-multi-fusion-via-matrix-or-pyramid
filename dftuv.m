function [U,V] = dftuv(M,N)
%   用于生成距离计算及其他应用所需的网格数组
%   M,N为网格大小
%   U,V为生成的网格数组
u=single(0:(M-1));
v=single(0:(N-1));

idx=find(u>M/2);
u(idx)=u(idx)-M;

idy=find(v>N/2);
v(idy)=v(idy)-N;

[V,U]=meshgrid(v,u);

end

