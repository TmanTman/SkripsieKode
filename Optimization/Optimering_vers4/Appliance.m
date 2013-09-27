%Skripsie
%Tielman Nieuwoudt
%4 Augustus 2013
%This file creates a class for configurable appliances

%Fields per appliance:
%Appliance.LB - Lower Boundary conditions
%Appliance.UB - Upper Boundary conditions
%Appliance.A - The A matrix for the linear constriants
%Appliance.b - The b matrix for the linear constraints
%Appliance.X0 - The beginvalues for the device

classdef Appliance
    properties 
        LB
        UB
        A
        b
        X0
    end
    methods
        function Appl = Appliance(LB, UB, A, b, X0)
            Appl.LB = LB;
            Appl.UB = UB;
            Appl.A = A;
            Appl.b = b;
            Appl.X0 = X0;
        end %function Appliance (Constructor)
    end %methods
end %classdef