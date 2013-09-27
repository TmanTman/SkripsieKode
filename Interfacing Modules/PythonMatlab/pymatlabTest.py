from pymatbridge import Matlab
mlab = Matlab()
mlab.start()

res = mlab.run_code('a=10, b=a+3')

mlab.stop()
