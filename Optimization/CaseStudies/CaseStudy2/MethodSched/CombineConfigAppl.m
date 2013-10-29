function [LB, UB, A, b, X0] = CombineConfigAppl( varargin )
%COMBINECONFIGAPPL Generates variables for patternsearch from all
%configurable appliances.
%   This function returns the variable matrices that can be provided to the
%   patternsearch method. The combination of the different appliances is
%   done for each of their properties: LB, UB, A, b, X0

%Determine the amount of variables for the problem
vars = 0;
for i=1:length(varargin)
    vars = vars+length(varargin{i}.LB);
end
%Preallocate memory to the LB, UB and X0  matrices (A and b handled in
%another function)
LB = zeros(1, vars);
UB = zeros(1, vars);
X0 = zeros(1, vars);
%Insert constraints of each appliance
start_col=1;
for i=1:length(varargin)
    %Update counters
    end_col=start_col+length(varargin{i}.LB)-1;
    LB(1, start_col:end_col) = varargin{i}.LB;
    UB(1, start_col:end_col) = varargin{i}.UB;
    X0(1, start_col:end_col) = varargin{i}.X0;
    start_col = end_col+1;
end

%Determine the dimensions of the new A matrix
rows = 0;
for i=1:length(varargin)
    rows = rows+size(varargin{i}.A, 1);
end

columns = 0;
for i=1:length(varargin)
    columns = columns+size(varargin{i}.A, 2);
end

%Preallocate the memory (preallocation for better performance)
A = zeros(rows, columns);
b = zeros(rows, 1);

%Counters to hold index of current row and column
[current_row, current_col] = deal(1);
%Iterate through each of the appliances and add it to the final matrices
for i=1:length(varargin)
    until_row = current_row+size(varargin{i}.A, 1)-1;
    until_col = current_col+size(varargin{i}.A, 2)-1;
    A(current_row:until_row, current_col:until_col) = varargin{i}.A; %Add the inequality matrix to the A matrix
    b(current_row:until_row, 1) = varargin{i}.b; %Add the inequalities to the b vector
    %Update counters
    current_row = until_row+1;
    current_col = until_col+1;
end