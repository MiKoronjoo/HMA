function [ y ] = removeNAN( input )
%REMOVENAN Summary of this function goes here
%   Detailed explanation goes here
L = length(input);
y = input(setdiff(1 : L, isnan(input)));
end

