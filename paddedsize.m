function PQ=paddedsize(AB,CD,PARAM)
%PADDEDSIZE(AB),Computs padded size useful fo TTT-based filtering

%ֵ����һ������Ĵ�Сʱ���ظþ����С������
if nargin==1
    PQ=2*AB;
%������������֤�Ĵ�Сʱ�����ش���������֤��С֮�ͼ�һ����Сż��
elseif nargin==2 && ~ischar(CD)
    PQ=AB+CD-1;
    PQ=2*ceil(PQ/2);
%������һ������Ĵ�С�ڶ�������Ϊ�ַ�ʱ��������ڸþ�֤��С��������С������
elseif nargin==2
    m=max(AB);
    P=2^nextpow2(2*m);
    PQ=[P,P];
%��������������ʱ���������������С����һ����Ĵ��ڸþ�֤��С��������С������
elseif nargin==3 && strcmpi(PARAM,'pwr2')
    m=max([AB CD]);
    P=2^nextpow2(2*m);
    PQ=[P,P];
else
    error('wrong number of inputs.');
end