%Tests various classes and scripts to ensure operation as expected.
%7 October 2013

%Test CombineConfig

%Build battery
A1=[0 1 0; 1 0 1; 1 1 1];
b1=[1;0;1];
LB1=[0 0 1];
UB1=[1 0 0];
X01=[0 0 0];
bat = Battery(LB1, UB1, A1, b1, X01);

%Build appliance 1
appl1 = Contr_Appl([21699 64800], [3600 7200]);

%Build appliance 2
appl2 = Contr_Appl(28800, 7200);

[LBf, UBf, Af, bf, X0f] = CombineConfigAppl(bat, appl1, appl2);
