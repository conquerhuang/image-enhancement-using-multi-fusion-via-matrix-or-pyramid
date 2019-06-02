function PQ=paddedsize(AB,CD,PARAM)
%PADDEDSIZE(AB),Computs padded size useful fo TTT-based filtering

%值输入一个矩阵的大小时返回该矩阵大小的两倍
if nargin==1
    PQ=2*AB;
%当输入两个举证的大小时，返回大于两个举证大小之和减一的最小偶数
elseif nargin==2 && ~ischar(CD)
    PQ=AB+CD-1;
    PQ=2*ceil(PQ/2);
%当输入一个矩阵的大小第二个参数为字符时，输出大于该举证大小两倍的最小二次幂
elseif nargin==2
    m=max(AB);
    P=2^nextpow2(2*m);
    PQ=[P,P];
%当输入三个参数时，返回两个矩阵大小最大的一个大的大于该举证大小两倍的最小二次幂
elseif nargin==3 && strcmpi(PARAM,'pwr2')
    m=max([AB CD]);
    P=2^nextpow2(2*m);
    PQ=[P,P];
else
    error('wrong number of inputs.');
end