%Universiteit Stellenbosch
%Skripsie
%Function: Database operations
%T Nieuwoudt
%27 September 2013

function [uncontrollable, geyser, poolpump] = DatabaseExtraction()

sqlite3.open('test.db')
sqlite3.execute('')