%% main function with overlap length statistics analysis
clc
clear all
close all

%% Read Data
% [A,words] = xlsread('datacopy.xls');
[A,words] = xlsread('WEBdatacopy.xls');          % simon's
words=words(1,1:2:end);
[row, col] = size(A);

nums = struct;

centroids = zeros(32, 3);

MFsHMWithout = zeros(32, 9);
CsHMWithout = zeros(32, 1);

%%  Compute the FOUs and centroids
for i = 1 : 32
    disp(words{i})
    L = A(1:row, 2*i-1);  %% Left end-points for interval data.
    R = A(1:row, 2*i);    %% Right end-points for interval data.
    
    % remove NANs
    L = removeNAN(L);
    R = removeNAN(R);
    
    [MFsHMWithout(i, :), num, shape, LL, RR] = HMWithoutExtensiveRemoval(L,R); %% Map into an IT2 FS
    newName = strrep(words{i}, ' ', '_');
    newName = strrep(newName, '-', '_');
    num = [length(L) num];
    nums.(newName)=num;

    CsHMWithout(i)=centroidIT2(MFsHMWithout(i,:)); %% Compute the centroid
    [a, b, c] = centroidIT2(MFsHMWithout(i,:));
    centroids(i, :) = [a, b, c];
    disp(' ')
end

[wordsHMWithout, MFsHMWithout] = plot32WordMFs(words, MFsHMWithout, CsHMWithout, 1);


%% Convergence simulations
% EIA paper Section IV.B
similarityTables = zeros(100, 32, 17);
for g = 1 : 100
    % we have in total 100 groups, for each group, we do the experiment for
    % each word
    for w = 1 : 32
        % the word loop
        disp(words{w})
        L = A(1:row, 2*w-1);  %% Left end-points for interval data.
        R = A(1:row, 2*w);    %% Right end-points for interval data.
        
        % the loop to use different number of responses
        availableIndices = 1 : 175; 
        sampledIndices = [];
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
            if length(tmp) == 9
                similarityTables(g, w, r) = Jaccard(tmp, MFsHMWithout(w, :));
            else
                similarityTables(g, w, r) = 0;
            end

        end
    end
end




