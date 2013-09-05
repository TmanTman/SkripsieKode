import numpy as np
import scipy.optimize as opt
import matplotlib.pyplot as plt

def objective(x, lights, pv_in, fig, ax, line1):
	grid_usage = 0
	for i in xrange(len(lights)):
		if lights[i]+pv_in[i]+x[i] > 0:
			grid_usage = grid_usage+lights[i]+pv_in[i]+x[i]
	##Graphing##
	line1.set_ydata(x)	
	fig.canvas.draw()
	####
	return grid_usage

def constr(x):
	##TEST WHETHER RETURNING -1 WOULD STILL WORK, OR DOES FUNCTION CHECK FOR IMPROVEMENT EACH ITERATION?
	#Bound constraints
	for j, val in enumerate(x):
	#Checks upper bound per element
		if val > 150:
			return 150 - x[j]
	#Checks that pump operates certain amount of time (energy) per day
	if sum(x) > 700:
		return 700 - sum(x)
	if sum(x) < 650:
		return sum(x) - 650
	#All tests passed successfully	
	return 1 	

##Init##
X0 = np.array([50, 50, 50, 50, 50, 50 ,50, 50, 50, 50, 50, 50])
lights  = [50, 50, 75, 150, 100, 100, 80, 80, 120, 180, 120, 100]
pv_in = [0, 0, 0, -50, -150, -300, -400, -300, -150, -50, 0, 0]
##Graphing##
plt.ion()
fig, ax = plt.subplots()
plt.xlim(0, 15)
plt.ylim(0, 200)
plt.xlabel('timeslot')
plt.title('Energy use')
bot = X0.min().round()
line1=ax.bar(np.arange(12), X0, bottom=0)
fig.canvas.draw()
##Optimization
x = opt.fmin_cobyla(objective, X0, cons=(constr,), args=(lights, pv_in, fig, ax, line1), consargs=(), rhoend=1e-7)

