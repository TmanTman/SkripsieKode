function [LB, UB, A, b, X0] = CombineConfigAppl( battery, varargin )
%COMBINECONFIGAPPL Generates variables for patternsearch from all
%configurable appliances.
%   This function returns the variable matrices that can be provided to the
%   patternsearch method. The combination of the different appliances is
%   done for each of their properties: LB, UB, A, b, X0

%Determine the amount of variables for the problem
vars = length(battery.LB);
for i=1:length(varargin)
    vars = vars+length(varargin{i}.LB);
end
%Preallocate memory to the LB, UB and X0  matrices (A and b handled in
%another function)
LB = zeros(1, vars);
UB = zeros(1, vars);
X0 = zeros(1, vars);
%Initialize counters
start_col = 1;
end_col = length(battery.LB);
%Insert battery into final LB, UB and X0
LB(1, start_col:end_col) = battery.LB;
UB(1, start_col:end_col) = battery.UB;
X0(1, start_col:end_col) = battery.X0;
%Insert constraints of each appliance in addition to battery
for i=1:length(varargin)
    %Update counters
    start_col=end_col+1;
    end_col=start_col+length(varargin{i}.LB)-1;
    LB(1, start_col:end_col) = varargin{i}.LB;
    UB(1, start_col:end_col) = varargin{i}.UB;
    X0(1, start_col:end_col) = varargin{i}.X0;
end

%Determine the dimensions of the new A matrix
rows = size(battery.A, 1); %The amount of inequalities 
for i=1:length(varargin)
    rows = rows+size(varargin{i}.A, 1);
end

columns = size(battery.A, 2); %The amount of vars in the battery
for i=1:length(varargin)
    columns = columns+size(varargin{i}.A, 2);
end


%Preallocate the memory (preallocation for better performance)
A = zeros(rows, columns);
b = zeros(rows, 1);

%Counters to hold index of current row and column
[current_row, current_col] = deal(1);
%Insert the battery A and b into the final A and b matrices
until_row = size(battery.A, 1);
until_col = size(battery.A, 2);
A(current_row:until_row, current_col:until_col) = battery.A;
b(current_col:until_row, 1) = battery.b;
%Update counters
current_row = until_row+1;
current_col = until_col+1;
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