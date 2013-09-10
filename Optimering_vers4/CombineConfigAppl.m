function [LB, UB, A, b, X0] = CombineConfigAppl( varargin )
%COMBINECONFIGAPPL Generates variables for patternsearch from all
%configurable appliances.
%   This function returns the variable matrices that can be provided to the
%   patternsearch method. The combination of the different appliances is
%   done for each of their properties: LB, UB, A, b, X0
appls = length(varargin);
timeslots = length(varargin{1}.X0);

%Preallocate memory to the LB, UB and X0  matrices (A and b handled in
%other function
LB = zeros(1, appls*timeslots);
UB = zeros(1, appls*timeslots);
X0 = zeros(1, appls*timeslots);
for i=1:appls
    LB(1, 1+(i-1)*timeslots:(i*timeslots)) = varargin{i}.LB;
    UB(1, 1+(i-1)*timeslots:(i*timeslots)) = varargin{i}.UB;
    X0(1, 1+(i-1)*timeslots:(i*timeslots)) = varargin{i}.X0;
end

%Determine the amount of inequalities to be combined, from the first
%object's A matrix
rows = 0;
for i=1:length(varargin)
    rows = rows+size(varargin{i}.A, 1);
end

%Preallocate the memory (preallocation for better performance)
A = zeros(rows, length(varargin)*timeslots);
b = zeros(rows, 1);

%Iterate through each of the pairs and add it to the final matrices
[eq_inserted, current_eq] = deal(0);
for i=1:length(varargin)
    current_eq = size(varargin{i}.A, 1); %Determine the amount of inequalities for the current appliance
    A((1+eq_inserted):(eq_inserted + current_eq), 1+(i-1)*timeslots:(i*timeslots)) = varargin{i}.A; %Add the inequality matrix to the A matrix
    b((1+eq_inserted):(eq_inserted + current_eq), 1) = varargin{i}.b; %Add the inequalities to the b vector
    eq_inserted = eq_inserted + current_eq; %Update the amount of ineqaulities inserted.
end