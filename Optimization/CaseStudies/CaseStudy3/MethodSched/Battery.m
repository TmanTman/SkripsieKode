%Skripsie
%Tielman Nieuwoudt
%4 Augustus 2013
%Major revision 4 October 2013
%This file creates a class for configurable appliances

%Fields per appliance:
%.LB - Lower Boundary conditions
%.UB - Upper Boundary conditions
%.A - The A matrix for the linear constriants
%.b - The b matrix for the linear constraints
%.X0 - The beginvalues for the device

classdef Battery
    properties 
        LB
        UB
        A
        b
        X0
    end
    methods
        function Bat = Battery(LB, UB, A, b, X0)
            Bat.LB = LB;
            Bat.UB = UB;
            Bat.A = A;
            Bat.b = b;
            Bat.X0 = X0;
        end %function Appliance (Constructor)
    end %methods
end %classdef