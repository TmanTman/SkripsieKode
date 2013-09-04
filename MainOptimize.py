from numpy import *
import scipy.optimize as opt

def objective(x):
	lights  = [50, 50, 75, 150, 100, 100, 80, 80, 120, 180, 120, 100]
	pv_in = [0, 0, 0, -50, -150, -300, -400, -300, -150, -50, 0, 0]
	grid_usage = 0
	for i in xrange(len(lights)):
		if lights[i]+pv_in[i]+x[i] > 0:
			grid_usage = grid_usage+lights[i]+pv_in[i]+x[i]
	return grid_usage

##Boundaries are not implementable in this form
#def manufact_constr(x):
#	#Bounds constraints	
#	constr = zeros((12))
#	for i in xrange(12):
#		constr[i] = (700 - x[i])
#	#Total use constraint
#	constr = append(constr, sum(x)-700)
#	constr = append(constr, 650-sum(x))
#	return constr

def constr(x):
	#Bound constraints
	for j, val in enumerate(x):
	#Checks upper bound per element
		if val > 150:
			return lambda x: 150 - x[j]
	#Checks that pump operates certain amount of time (energy) per day
	if sum(x) > 700:
		return lambda x: 700 - sum(x)
	if sum(x) < 650:
		return lambda x: sum(x) - 650
	#All tests passed successfully	
	return 1 	

X0 = [50, 50, 50, 50, 50, 50 ,50, 50, 50, 50, 50, 50]
opt.fmin_cobyla(objective, X0, cons=(constr,), rhoend=1e-7)
