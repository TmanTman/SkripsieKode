%Skripsie
%Tielman Nieuwoudt
%4 Oktober 2013
%This file creates a class for configurable appliances

%Fields per appliance:
%.LB - Lower Boundary conditions
%.UB - Upper Boundary conditions
%.A - The A matrix for the linear constriants
%.b - The b matrix for the linear constraints
%.X0 - The beginvalues for the device
%.D - The duration of each period
%.demand - The demand energy level (demand*dutycycle)


classdef Contr_Appl
    properties 
        LB
        UB
        A
        b
        X0
        d
        demand
    end
    methods
        function Appl = Contr_Appl(X0, D, demand)
            N = length(X0);
            Appl.LB = zeros(1, N);
            Appl.UB = 24*3600*ones(1, N);
            Appl.X0 = X0;
            Appl.d = D;
            Appl.demand = demand;
            %Create A and b vector
            %Initialize
            Appl.A = zeros(N+1, N);
            Appl.b = zeros(N+1, 1);
            %Make the boundary entries
            Appl.A(1,1) = -1;
            Appl.b(1) = 0;
            Appl.A(2,N) = 1;
            Appl.b(2) = 24*3600 - D(N);
            %Make the entries inbetween
            if N>1
                for i=1:(N-1)
                    Appl.A(2+i,i) = 1;
                    Appl.A(2+i,i+1) = -1;
                    Appl.b(2+i) = -D(i);
                end
            end
        end %function Appliance (Constructor)
    end %methods
end %classdef