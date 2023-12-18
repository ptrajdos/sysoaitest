PYTHON = python
MPIEXEC = mpiexec

ROOTDIR=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
CODEDIR=${ROOTDIR}/code

.PHONY: all

all: numpy sklearn matplotlib keras cython pyopencl mpi threads joblib pyopenclimage spark tqdm skimage opencv

numpy:
	${PYTHON} ${CODEDIR}/numpyT.py
sklearn: 
	${PYTHON} ${CODEDIR}/sklearnT.py

matplotlib: 
	${PYTHON} ${CODEDIR}/matplotlibT.py

keras: 
	${PYTHON} ${CODEDIR}/kerasT.py

cython: 
	cd ${CODEDIR} && ${PYTHON} ./cythonSumT.py

pyopencl: 
	${PYTHON} ${CODEDIR}/pyopenclT.py

mpi: 
	${MPIEXEC}	${PYTHON} ${CODEDIR}/mpiT.py

threads: 
	${PYTHON} ${CODEDIR}/threadsT.py

joblib: 
	${PYTHON} ${CODEDIR}/threadsT.py

pyopenclimage: 
	cd ${CODEDIR} && ${PYTHON} ./imageFillIntT.py

spark: 
	${PYTHON} ${CODEDIR}/sparkT.py

tqdm: 
	${PYTHON} ${CODEDIR}/tqdmT.py

skimage: 
	${PYTHON} ${CODEDIR}/skimageT.py

opencv: 
	cd ${CODEDIR} && ${PYTHON} ./opencvT.py

tensorflow: 
	${PYTHON} ${CODEDIR}/tensorflowT.py