import numpy
import scipy.optimize as opt

def objective(x):
	return x[0]*x[1]

def constr1(x):
	return 1 - (x[0]**2 + x[1]**2)

def constr2(x):
	return x[1]

opt.fmin_cobyla(objective, [0.0, 0.1], [constr1, constr2], rhoend=1e-7)
