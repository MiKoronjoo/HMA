function [MF, nums, shape, FSL, FSR] = HMAWithoutExtensiveRemovalProbability(L, R, inputShape)
%
index=find(isnan(L)+isnan(R)); % remove incomplete data
L(index)=[];
R(index)=[];

%% Bad data processing, see Equation (1) in paper
for i=length(L):-1:1
    if L(i)<0 | L(i)>1 | R(i)<0 | R(i)>1 |  R(i)<=L(i) | R(i)-L(i)>=1
        L(i) = [];
        R(i) = [];
    end
end
nums=length(L); % n'

%% Outlier processing
intLeng = R-L;
left = sort(L);
right = sort(R);
leng = sort(intLeng);

NN1 = floor(nums * 0.25);
NN2 = floor(nums * 0.75);

% Compute Q(0.25), Q(0.75) and IQR for left-ends
QL25 = left(NN1)*(1-rem(0.25*nums,1)) + left(NN1+1)*rem(0.25*nums,1);
QL75 = left(NN2)*(1-rem(0.75*nums,1)) + left(NN2+1)*rem(0.75*nums,1);
LIQR = QL75 - QL25;

% Compute Q(0.25), Q(0.75) and IQR for right-ends.
QR25 = right(NN1)*(1-rem(0.25*nums,1)) + right(NN1+1)*rem(0.25*nums,1);
QR75 = right(NN2)*(1-rem(0.75*nums,1)) + right(NN2+1)*rem(0.75*nums,1);
RIQR = QR75 - QR25;

% outlier processing for L and R
for i=nums:-1:1
    if L(i)<QL25-1.5*LIQR | L(i)>QL75+1.5*LIQR | R(i)<QR25-1.5*RIQR | R(i)>QR75+1.5*RIQR
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n1 = length(L);

% Compute Q(0.25), Q(0.75) and IQR for interval length.
NN1 = floor(n1 * 0.25);
NN2 = floor(n1 * 0.75);
QLeng25 = leng(NN1)*(1-rem(0.25*n1,1)) + leng(NN1+1)*rem(0.25*n1,1);
QLeng75 = leng(NN2)*(1-rem(0.75*n1,1)) + leng(NN2+1)*rem(0.75*n1,1);
lengIQR = QLeng75 - QLeng25;

% outlier processing for interval length
for i=n1:-1:1
    if intLeng(i)<QLeng25-1.5*lengIQR | intLeng(i)>QLeng75+1.5*lengIQR
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n1 = length(L);
nums=[nums n1]; % m'

%% Tolerance limit processing, see Equation (3) in paper
meanL = mean(L);
stdL = std(L);
meanR = mean(R) ;
stdR = std(R);

K=[32.019 32.019 8.380 5.369 4.275 3.712 3.369 3.136 2.967 2.839...
    2.737 2.655 2.587 2.529 2.48 2.437 2.4 2.366 2.337 2.31...
    2.31 2.31 2.31 2.31 2.208];
k=K(min(n1,25));

%% Tolerance limit processing for L and R
for i=n1:-1:1
    if L(i)<meanL-k*stdL | L(i)>meanL + k*stdL | R(i)<meanR-k*stdR | R(i)>meanR + k*stdR
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n1 = length(L);
% nums=[nums n1]; % m+

%% Tolerance limit processing for interval length
meanLeng = mean(intLeng);
stdLeng = std(intLeng);

k=min([K(min(n1,25)),meanLeng/stdLeng,(10-meanLeng)/stdLeng]);
% k = 2.58;
for i=n1:-1:1
    if  intLeng(i)<meanLeng-k*stdLeng | intLeng(i)>meanLeng + k*stdLeng
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n1 = length(L);
nums=[nums n1]; %m''


%% Reasonable interval processing, see Equation (4)-(6) in paper
meanL = mean(L);
stdL = std(L);
meanR = mean(R) ;
stdR = std(R);

% Determine sigma*
if stdL==stdR
    barrier = (meanL + meanR)/2;
elseif stdL==0
    barrier = meanL+0.01;
elseif stdR==0
    barrier = meanR-0.01;
else
    barrier1 =(meanR*stdL^2-meanL*stdR^2 + stdL*stdR*sqrt((meanL-meanR)^2+2*(stdL^2-stdR^2)*log(stdL/stdR)))/(stdL^2-stdR^2);
    barrier2 =(meanR*stdL^2-meanL*stdR^2 - stdL*stdR*sqrt((meanL-meanR)^2+2*(stdL^2-stdR^2)*log(stdL/stdR)))/(stdL^2-stdR^2);
    if  barrier1>=meanL & barrier1<=meanR
        barrier = barrier1;
    else
        barrier = barrier2;
    end
end

% Reasonable interval processing
for i=n1:-1:1
    if L(i)>=barrier | R(i)<= barrier | L(i)<2*meanL-barrier | R(i)>2*meanR-barrier
        L(i) = [];
        R(i) = [];
        intLeng(i)=[];
    end
end
n=length(L);
nums=[nums  n]; %m

meanL = mean(L);
stdL = std(L);
meanR = mean(R) ;
stdR = std(R);



K=[32.019 32.019 8.380 5.369 4.275 3.712 3.369 3.136 2.967 2.839...
    2.737 2.655 2.587 2.529 2.48 2.437 2.4 2.366 2.337 2.31...
    2.31 2.31 2.31 2.31 2.208];
k=K(min(n1,25));

% k = toleranceFactor(n1, 'TwoSided');

%% Allow user to type the input shape: 1 left-shoulder, 2: interior and 3: right-shoulder
if nargin < 3
    if (meanL-k*stdL <= 0)
        shape = 1;  % left
    elseif (meanR + k*stdR >= 10)
        shape = 3;  % right
    else
        shape = 2;  % interior
    end
elseif nargin == 3
    shape = inputShape;    
end

% Establish nature of FOU, see Equation (19) in paper
if (shape == 1)
    %% left shoulder
    switchPoint = min(R);
    nums=[nums length(R)]; %m*
    
    FSL = zeros(1, length(L));
    FSR = zeros(1, length(R));
    
    if (sum(R - switchPoint) == 0)
        UMF = [0, 0, switchPoint, switchPoint];
        LMF = [0, 0, switchPoint, switchPoint, 1];
    
        shape=1;
        MF=[UMF LMF];
        return
    end
    
    %% side parts
    c = switchPoint;
    subsetRightLength = R - c;
    
    %% remove the empty intervals
    subsetRightLength(subsetRightLength <= 0) = [];
    %% calculate the mean and sd of the lengths
    lengthMean = mean(subsetRightLength);
    lengthSD = std(subsetRightLength);
    
    %% map the center of the std and upper mean
    d = min(c + 3 * sqrt(2) * lengthSD, 1);
    i = min(6 * (c + lengthMean) - 4 * c - d, 1);
    
    bl = max(min(d, i), c);
    br = max(d, i);
    
    UMF = [0, 0, switchPoint, br];
    LMF = [0, 0, switchPoint, bl, 1];
elseif  (shape == 3)
    %% right shoulder
    switchPoint = max(L);

    nums=[nums length(L)]; %m*
    
    FSL = zeros(1, length(L));
    FSR = zeros(1, length(R));
    
    if (sum(L - switchPoint) == 0)
        UMF = [switchPoint, switchPoint, 1, 1];
        LMF = [switchPoint, switchPoint, 1, 1, 1];
    
        shape=3;
        MF=[UMF LMF];
        return
    end
    
    %% side parts
    c = switchPoint;
    subsetRightLength = c - L;
    
    %% remove the empty intervals
    subsetRightLength(subsetRightLength <= 0) = [];

    %% calculate the mean and sd of the lengths
    lengthMean = mean(subsetRightLength);
    lengthSD = std(subsetRightLength);
    

    %% map the center of the std and lower mean
    a = max(0, c - 3 * sqrt(2) * lengthSD);
    e = max(6 * (c - lengthMean) - 4 * c - a, 0);

    
    al = min(a, e);
    ar = max(e, a);
    
    UMF = [al, switchPoint, 1, 1];
    LMF = [ar, switchPoint, 1, 1, 1];
else
    overlapLeft = max(L);
    overlapRight = min(R);
    
    nums=[nums length(L) length(R)]; %m*'s
    
    FSL = zeros(length(L), 1);
    FSR = zeros(length(R), 1);


    %% side parts
    c = overlapLeft;
    subsetRightLength = c - L;
    
    %% remove the empty intervals
    subsetRightLength(subsetRightLength <= 0) = [];

    %% calculate the mean and sd of the lengths
    lengthMean = mean(subsetRightLength);
    lengthSD = std(subsetRightLength);
    

    %% map the center of the std and lower mean
    a = max(0, c - 3 * sqrt(2) * lengthSD);
    e = max(0, 6 * (c - lengthMean) - 4 * c - a);
    
    al = min(a, e);
    ar = min(max(e, a), c);
    
    c = overlapRight;
    subsetRightLength = R - c;
    
    %% remove the empty intervals
    subsetRightLength(subsetRightLength <= 0) = [];
    %% calculate the mean and sd of the lengths
    lengthMean = mean(subsetRightLength);
    lengthSD = std(subsetRightLength);
    
    %% map the center of the std and upper mean
    d = min(c + 3 * sqrt(2) * lengthSD, 1);
    i = min(6 * (c + lengthMean) - 4 * c - d, 1);
    
    bl = max(min(d, i), c);
    br = max(d, i);
    
    UMF = [al, overlapLeft, overlapRight, br];
    LMF = [ar, overlapLeft, overlapRight, bl, 1];
end

MF=[UMF LMF];




