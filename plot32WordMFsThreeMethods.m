function [words1, MFs] = plot32WordMFsThreeMethods( words, IAs, EIAs, HMs, IACs, EIACs, HMCs )
%PLOT32WORDMFS Summary of this function goes here
%   Detailed explanation goes here

%% Sort the MFs in ascending order according to the centers of centroids
[Cs,index]=sort(Cs);  % Sort the centers of the centroids
MFs=MFs(index,:);
words1=words(index); % Reorder the names of words

% if f == 1
%     t = words1{20};
%     words1{20} = words1{21};
%     words1{21} = t;
%     
%     t = MFs(20, :);
%     MFs(20, :) = MFs(21, :);
%     MFs(21, :) = t;
% end

%% Plot the ordered interval type-2 word models
figure
set(gcf,'DefaulttextFontName','times new roman');
set(gcf,'DefaultaxesFontName','times new roman');
set(gcf,'DefaulttextFontAngle','italic');
for i = 1 : 32
    subplot(8,6,2*floor((i-1)/4)+i);
%     plotIT2(MFs1(i,:),[0,10]);
    myplotIT2(MFs(i,:));
    title(words1(i),'fontsize',9);
    set(gca,'YTick',[]);
    set(gca,'XTick',[]);
    axis([0 10 0 1]);
end
end

