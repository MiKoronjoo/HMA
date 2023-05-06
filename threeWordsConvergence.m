%% Plot Tiny, Some and Large for convergence
close all
clear all
clc

%% Read Data
% [A,words] = xlsread('datacopy.xls');
[A,words] = xlsread('WEBdatacopy.xls');          % simon's
words=words(1,1:2:end);
[row, col] = size(A);

%% Tiny
tinyFOUs = zeros(18, 100, 9);
tinyIdx = 30;
for g = 1 : 100
    % we have in total 100 groups
    L = A(1:row, 2 * tinyIdx-1);  %% Left end-points for interval data.
    R = A(1:row, 2 * tinyIdx);    %% Right end-points for interval data.
    sampledIndices = [];
    availableIndices = 1 : 175;
    for r = 1 : 17
        % sample 10 more response indices from remaining indices
        sampledIndices = [sampledIndices, randsample(availableIndices, 10)];
        % update the availableIndices
        availableIndices = setdiff(1 : 175, sampledIndices);

        % use the current sampledIndices to construct the FOUs using
        % the HM method            
        subL = L(sampledIndices);
        subR = R(sampledIndices);

        % remove NANs
        subL = removeNAN(subL);
        subR = removeNAN(subR);

        [tmp, num, shape, LL, RR] = HMWithoutExtensiveRemoval(subL, subR); %% Map into an IT2 FS
        tinyFOUs(r, g, :) = tmp;
    end
    tinyFOUs(18, g, :) = [0, 0, 0.23, 1.88, 0, 0, 0.23, 1.36, 1];
end

tinyFOU = zeros(18, 9);

for i = 1 : 18
    tmp = zeros(1, 9);
    for j = 1 : 100
        tmp = tmp + squeeze(tinyFOUs(i, j, :))';
    end
    tinyFOU(i, :) = tmp / 100;
end

plot18WordMFs(tinyFOU)


%% Some
someFOUs = zeros(18, 100, 9);
someIdx = 29;
for g = 1 : 100
    % we have in total 100 groups
    L = A(1 : row, 2 * someIdx - 1);  %% Left end-points for interval data.
    R = A(1 : row, 2 * someIdx);    %% Right end-points for interval data.
    sampledIndices = [];
    availableIndices = 1 : 175;
    for r = 1 : 17
        % sample 10 more response indices from remaining indices
        sampledIndices = [sampledIndices, randsample(availableIndices, 10)];
        % update the availableIndices
        availableIndices = setdiff(1 : 175, sampledIndices);

        % use the current sampledIndices to construct the FOUs using
        % the HM method            
        subL = L(sampledIndices);
        subR = R(sampledIndices);

        % remove NANs
        subL = removeNAN(subL);
        subR = removeNAN(subR);

        [tmp, num, shape, LL, RR] = HMWithoutExtensiveRemoval(subL, subR); %% Map into an IT2 FS
        someFOUs(r, g, :) = tmp;
    end
    someFOUs(18, g, :) = [0, 3.15, 3.37, 6.81, 0.09, 3.15, 3.37, 5.95, 1];
end

someFOU = zeros(18, 9);
for i = 1 : 18
    tmp = zeros(1, 9);
    for j = 1 : 100
        tmp = tmp + squeeze(someFOUs(i, j, :))';
    end
    someFOU(i, :) = tmp / 100;
end

plot18WordMFs(someFOU)

%% Large
largeFOUs = zeros(18, 100, 9);
largeIdx = 3;
for g = 1 : 100
    % we have in total 100 groups
    L = A(1 : row, 2 * largeIdx - 1);  %% Left end-points for interval data.
    R = A(1 : row, 2 * largeIdx);    %% Right end-points for interval data.
    sampledIndices = [];
    availableIndices = 1 : 175;
    for r = 1 : 17
        % sample 10 more response indices from remaining indices
        sampledIndices = [sampledIndices, randsample(availableIndices, 10)];
        % update the availableIndices
        availableIndices = setdiff(1 : 175, sampledIndices);

        % use the current sampledIndices to construct the FOUs using
        % the HM method            
        subL = L(sampledIndices);
        subR = R(sampledIndices);

        % remove NANs
        subL = removeNAN(subL);
        subR = removeNAN(subR);

        [tmp, num, shape, LL, RR] = HMWithoutExtensiveRemoval(subL, subR); %% Map into an IT2 FS
        largeFOUs(r, g, :) = tmp;
    end
    largeFOUs(18, g, :) = [3.23, 8.62, 10, 10, 5.81, 8.62, 10, 10, 1];
end

largeFOU = zeros(18, 9);
for i = 1 : 18
    tmp = zeros(1, 9);
    for j = 1 : 100
        tmp = tmp + squeeze(largeFOUs(i, j, :))';
    end
    largeFOU(i, :) = tmp / 100;
end

plot18WordMFs(largeFOU)