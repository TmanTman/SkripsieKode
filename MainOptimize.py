import numpy
import scipy.optimize as opt

def objective(x):
	grid_usage = 0
	for i in lights:
		if ligths[i]+pv_in[i]+x[i] > 0:
			grid_usage = grid_usage+lights[i]+pv_in[i]+x[i]
	return grid_usage

def constr1(x):
	

lights  = array([50, 50, 75, 150, 100, 100, 80, 80, 120, 180, 120, 100])
pv_in = array([0, 0, 0, 50, 150, 300, 400, 300, 150, 50, 0, 0])
X0 = ones(12)*50
opt.fmin_cobyla(objective, [0.0, 0.1], constr, rhoend=1e-7)
