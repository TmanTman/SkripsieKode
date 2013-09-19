import numpy as np
import scipy.optimize as opt
import matplotlib.pyplot as plt

cost_global = np.array([0])

def add3Array(arr1, arr2, arr3):
	arr1 = np.add(arr1, arr2)
	arr1 = np.add(arr1, arr3)
	return arr1 
	
def gridPay (gridusage):
	grid_chargedFor= 0
	for i, val in enumerate(gridusage):
		if val > 0:
			grid_chargedFor += val
	return grid_chargedFor

def redrawGraph(x, y, ax, title):
	ax.clear()
	ax.set_title(title)
	ax.bar(x, y)

def objective(x, lights, pv_in, ax_x, ax_grid, ax_func, timeslots):
	global cost_global
	grid_usage = add3Array(lights, pv_in, x)
	cost_global = np.append(cost_global, gridPay(grid_usage))
	##Graphing##
	redrawGraph(timeslots, grid_usage, ax_grid, 'Grid')
	redrawGraph(timeslots, x, ax_x, 'Controllable')
	ax_func.clear()
	ax_func.locator_params(nbins=4)
	ax_func.set_title('Function value')
	ax_func.scatter(np.arange(len(cost_global)), cost_global)
	plt.draw()
	####
	return gridPay(grid_usage)

def constr(x):
	##TEST WHETHER RETURNING -1 WOULD STILL WORK, OR DOES FUNCTION CHECK FOR IMPROVEMENT EACH ITERATION?
	#Bound constraints
	for j, val in enumerate(x):
		print 'Element: ', j, ': ', val
	#Checks lower bound per element
		if val < 0:
			return val
	#Checks upper bound per element
		elif val > 150:
			return 150 - val
	#Checks that pump operates certain amount of time (energy) per day
	print sum(x)
	if sum(x) > 700:
		print 'Returning: ', 700 - sum(x)
		return 700 - sum(x)
	if sum(x) < 500:
		print 'Returning: ', sum(x) - 500
		return sum(x) - 500
	#All tests passed successfully	
	return 1 	

##Init##
X0 = np.array([50, 50, 50, 50, 50, 50 ,50, 50, 50, 50, 50, 50])
lights  = np.array([50, 50, 75, 150, 100, 100, 80, 80, 120, 180, 120, 100])
pv_in = np.array([0, 0, 0, -50, -150, -300, -400, -300, -150, -50, 0, 0])
grid_usage_profile = add3Array(X0, lights, pv_in)
cost_global[0] = gridPay(grid_usage_profile)
##Graphing##
timeslots = np.arange(12)
plt.ion()
fig, ((ax1, ax2, axA), (ax3, ax4, axB)) = plt.subplots(2, 3, sharey='row', sharex='column')
ax5 = fig.add_subplot(2, 3, 3)
ax1.bar(timeslots, lights)
ax1.set_title('Lights')
ax2.bar(timeslots, np.dot(-1, pv_in))
ax2.set_title('PV in')
ax3.bar(timeslots, X0)
ax3.set_title('Controllable loads')
ax4.bar(timeslots, grid_usage_profile)
ax4.set_title('Energy from grid')
ax5.scatter(np.arange(len(cost_global)), cost_global)
ax5.set_title('Function Value')
ax5.locator_params(nbins=4)
plt.tight_layout()
plt.draw()
print 'This iterations cost: ', cost_global
##Optimization
x = opt.fmin_cobyla(objective, X0, cons=(constr,), args=(lights, pv_in, ax3, ax4, ax5, timeslots), consargs=(), rhobeg=10, rhoend=0.001, maxfun=5000)

