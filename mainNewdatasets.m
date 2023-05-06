%% three new data sets in Perceptual Computing book
clear all
close all
clc

load('newDatasets.mat')

%% Read Data
%%%%% Dataset 1
words = {'None to very little', 'Extremely low', 'Very low', 'More or less low', ...
    'Somewhat low', 'Moderately low', 'Low', 'From low to more or less fair', ...
    'From fair to more or less high', 'Somewhat high', 'Moderately high', ... 
    'More or less high', 'High', 'Very high', 'Extremely high'};
[row, col] = size(NewDataSet1);

MFs = zeros(col / 2, 9);
CsHMWithout = zeros(col / 2, 1);
centroids = zeros(col / 2, 3);
nums = struct;

%%  Compute the FOUs and centroids
for i = 1 : col / 2
    disp(words{i})
    L = NewDataSet1(1:row, 2*i-1);  %% Left end-points for interval data.
    R = NewDataSet1(1:row, 2*i);    %% Right end-points for interval data.
    
    % remove NANs
    L = removeNAN(L);
    R = removeNAN(R);
    [MFs(i, :), num, shape, LL, RR] = HMAWithoutExtensiveRemoval(L,R); %% Map into an IT2 FS
%     [MFs1(i,:), num, shape, LL, RR] = newEIAGaussianTestRemoveOneDataIntervalATime(L,R); %% Map into an IT2 FS
    newName = strrep(words{i}, ' ', '_');
    newName = strrep(newName, '-', '_');
    num = [length(L) num];
    nums.(newName)=num;
    
    CsHMWithout(i)=centroidIT2(MFs(i,:)); %% Compute the centroid
    [a, b, c] = centroidIT2(MFs(i,:));
    centroids(i, :) = [a, b, c];
    disp(' ')
end

%% dataset1
plot16WordMFs(words, MFs, CsHMWithout);
 
%%%% Dataset 2
words = {'Very bad', 'More or less bad', 'Somewhat bad', 'Bad', 'Somewhat fair', ... 
    'Fair', 'Very fair', 'More or less good', 'Somewhat good', 'Good', ... 
    'Very good'};

[row, col] = size(NewDataSet2);

MFs = zeros(col / 2, 9);
CsHMWithout = zeros(col / 2, 1);
centroids = zeros(col / 2, 3);
nums = struct;

%%  Compute the FOUs and centroids
for i = 1 : col / 2
    disp(words{i})
    L = NewDataSet1(1:row, 2*i-1);  %% Left end-points for interval data.
    R = NewDataSet1(1:row, 2*i);    %% Right end-points for interval data.
    
    % remove NANs
    L = removeNAN(L);
    R = removeNAN(R);
    [MFs(i, :), num, shape, LL, RR] = HMAWithoutExtensiveRemoval(L,R); %% Map into an IT2 FS
%     [MFs1(i,:), num, shape, LL, RR] = newEIAGaussianTestRemoveOneDataIntervalATime(L,R); %% Map into an IT2 FS
    newName = strrep(words{i}, ' ', '_');
    newName = strrep(newName, '-', '_');
    num = [length(L) num];
    nums.(newName)=num;
    
    CsHMWithout(i)=centroidIT2(MFs(i,:)); %% Compute the centroid
    [a, b, c] = centroidIT2(MFs(i,:));
    centroids(i, :) = [a, b, c];
    disp(' ')
end

plot11WordMFs(words, MFs, CsHMWithout);

%%% dataset3
words = {'UI', 'MUI', 'MLUI', ... 
    'MI', 'MLI', 'VI'};

[row, col] = size(NewDataSet3);


MFs = zeros(col / 2, 9);
CsHMWithout = zeros(col / 2, 1);
nums = struct;
centroids = zeros(col / 2, 3);

%%  Compute the FOUs and centroids
for i = 1 : col / 2
    disp(words{i})
    L = NewDataSet2(1:row, 2*i-1);  %% Left end-points for interval data.
    R = NewDataSet2(1:row, 2*i);    %% Right end-points for interval data.
    
    % remove NANs
    L = removeNAN(L);
    R = removeNAN(R);
    [MFs(i, :), num, shape, LL, RR] = HMAWithoutExtensiveRemoval(L,R); %% Map into an IT2 FS
%     [MFs1(i,:), num, shape, LL, RR] = newEIAGaussianTestRemoveOneDataIntervalATime(L,R); %% Map into an IT2 FS
    newName = strrep(words{i}, ' ', '_');
    newName = strrep(newName, '-', '_');
    num = [length(L) num];
    nums.(newName)=num;
    
    CsHMWithout(i)=centroidIT2(MFs(i,:)); %% Compute the centroid
    [a, b, c] = centroidIT2(MFs(i,:));
    centroids(i, :) = [a, b, c];
    disp(' ')
end

%% dataset3
[wordsSort, MFs, index] = plot6WordMFs(words, MFs, CsHMWithout);
sortedCs = centroids(index, :);