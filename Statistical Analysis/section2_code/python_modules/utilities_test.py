from utilities import *
import numpy

array=numpy.arange(100)
array=array.reshape(10,10)
print(get_tile((2,4),3,array))