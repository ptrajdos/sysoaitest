cdef long c_sum(long n):
	if n < 0:
		return 0
	cdef long sum=0
	cdef long i
	for i in range(n): #this will become a pure C loop
		sum+=i
	return sum

cdef long c_sum2(long n):
	if n < 0:
		return 0
	cdef:
		int i
		long sum=0
	for i in range(n):
		sum+=i
	return sum

def p_sum2(n):
	return c_sum2(n)

cpdef double c_sum3(long n):
	if n <= 0:
		return 0
	cdef: 
		double i
		double sum=0
	for i in range(1,n):
		sum+= 1.0/i
	return sum

