function S=Jaccard(A,B)

%
% S=Jaccard(A,B)
%
% To compute the Jaccard similarity measure between two IT2 FSs. 
%
% Dongrui Wu and Jerry M. Mendel, “A comparative study of ranking
% methods, similarity measures and uncertainty measures for interval 
% type-2 fuzzy sets,” submitted to Information Sciences, 2008.
%
% Dongrui WU (dongruiw@usc.edu), 5/12/2008
%
% A, B: IT2 FSs each defined by nine parameters (see Fig. 1 in Readme.doc)
%
% S: The Jaccard similarity measure

N=200; % number of discretizations
minX=min(A(1),B(1)); % the range
maxX=max(A(4),B(4));
X=linspace(minX,maxX,N);

lowerA=mg(X,A(5:8),[0 A([9 9]) 0]);
upperA=mg(X,A(1:4));
lowerB=mg(X,B(5:8),[0 B([9 9]) 0]);
upperB=mg(X,B(1:4));

S=sum([min([upperA;upperB]), min([lowerA;lowerB])])/sum([max([upperA;upperB]), max([lowerA;lowerB])]);



