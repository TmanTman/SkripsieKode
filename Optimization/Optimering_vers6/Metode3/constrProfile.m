function [ prof ] = constrProfile( X, d, demand)
%CONSTRPROFILE Constructs profile from start times and durations
%The following mechanism is applied:
%The first and last profiles are written, and those inbetween are filled in
%Different code is executed for one element and two+ elements
    profile = zeros(1, 48);
    %Gather info regarding starting times
    index_of_start = floor(X(1, 1)/1800)+1
    halfhour_after_start = ceiling(X(1,1)/1800)*1800
    if ((X{i}+d) < halfhour_after_start) %Single element
        profile(index_of_start) = d*demand;
    else %Make last element entry and then fill in the middle elements
        index_of_end = ceiling((X(1, 1)+d)/1800);
        halfhour_before_end = 
        profile(index_of_start) = (halfhour_after_start-X{i})*demand %First Element entry

    %Find relevant information for first profile entry:
    halfhour_before_start = floor(X(1,1)/1800)*1800;



    %First profile entry
    if mod(X(1, 1), 1800) == 0
        profile(index_of_start) = (0.5*demand);%0.5 indicates half hour
    else
        profile(index_of_start) = (halfhour_after_start

    %Find relevant information for last profile entry:
    halfhour_before_end = 


end

