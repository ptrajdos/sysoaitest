from mpi4py import MPI
import os
if __name__ == '__main__':

	# Initializing communicator (responsible for process communication)
	comm = MPI.COMM_WORLD
	#Ranks are processes IDs
	rank = comm.Get_rank() # Rank of a process who calls this function
	size = comm.Get_size() # Total number of processes in communicator

	# All processes run the same code
	print("Hello World from process: {rnk}/{size}, PID {pid}".format(rnk=rank,size=size,pid=os.getpid()),flush=True)