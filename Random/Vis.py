import numpy as np
import scipy.optimize as opt
import matplotlib.pyplot as plt
import time

x = np.arange(12)
X0 = np.array([50, 50, 50, 50, 50, 50 ,50, 50, 50, 50, 50, 50])

fig = plt.figure()
ax = fig.add_subplot(111)
line1,=ax.plot(x, X0, 'r-')

plt.show()

time.sleep(2)
X1 = np.array([50, 50, 100, 50, 50, 150 ,50, 50, 50, 50, 50, 50])

line1.set_ydata(X1)
fig.canvas.draw()

plt.show()
