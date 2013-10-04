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
%.D = The duration of each period

classdef Appliance
    properties 
        LB
        UB
        A
        b
        X0
        d
    end
    methods
        function Appl = Appliance(LB, UB, A, b, X0, d)
            Appl.LB = LB;
            Appl.UB = UB;
            Appl.A = A;
            Appl.b = b;
            Appl.X0 = X0;
            Appl.d = d;
        end %function Appliance (Constructor)
    end %methods
end %classdef