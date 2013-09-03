import numpy
import scipy.optimize as opt

def objective(x):
	lights  = [50, 50, 75, 150, 100, 100, 80, 80, 120, 180, 120, 100]
	pv_in = [0, 0, 0, 50, 150, 300, 400, 300, 150, 50, 0, 0]
	grid_usage = 0
	for i in lights:
		if ligths[i]+pv_in[i]+x[i] > 0:
			grid_usage = grid_usage+lights[i]+pv_in[i]+x[i]
	return grid_usage

def constr1(x):
	#Bounds constraints	
	constr = []
	for i in xrange(12):
		constr.append = 700 - x[i]
	Total use constraint
	constr.append(sum(x)-700)
	constr.append(650-sum(x))
	return constr
	
X0 = [50, 50, 50, 50, 50, 50 ,50, 50, 50, 50, 50, 50]
opt.fmin_cobyla(objective, X0, constr1, rhoend=1e-7)
