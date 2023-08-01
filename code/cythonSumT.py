import pyximport
pyximport.install()
import cythonSum as cs

if __name__ == '__main__':
	n = 10
	#print("Sum is: ",cs.c_sum(n)) #AttributeError: module 'cythonSum' has no attribute 'c_sum'
	print("Sum2 is: ",cs.p_sum2(n))
	print("Sum3 is: ",cs.c_sum3(n))
