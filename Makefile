PYTHON = python
MPIEXEC = mpiexec

ROOTDIR=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
CODEDIR=${ROOTDIR}/code
ASDF_DIR := $(HOME)/.asdf
PACKAGES_FILE=${ROOTDIR}/mint_packages.txt
ASDF=asdf
PYTHON=python
PIP=pip
.PHONY: all

all: install tests

tests: numpy sklearn matplotlib keras cython pyopencl mpi threads joblib pyopenclimage spark tqdm skimage opencv

install: asdf_install_python


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

git:
	apt install -y git

$(ASDF_DIR): install_packages
	git clone https://github.com/asdf-vm/asdf.git ${ASDF_DIR} --branch v0.14.1;\
	echo '. "$$HOME/.asdf/asdf.sh"' >>${HOME}/.bashrc;\
	echo '. "$$HOME/.asdf/completions/asdf.bash"' >>${HOME}/.bashrc; \

asdf_plugins: $(ASDF_DIR)
	source ${HOME}/.bashrc ;\
	asdf plugin-add python ;\
	asdf plugin-add java

install_packages:
	sudo xargs -a ${PACKAGES_FILE} apt install -y

asdf_install_python: asdf_plugins
	source ${HOME}/.bashrc ;\
	$(ASDF) install python 3.11.9 ;\
	$(ASDF) global python 3.11.9 ;\
	$(PYTHON) -m $(PIP) install --upgrade pip ;\
	$(PYTHON) -m $(PIP) install -r ${ROOTDIR}/requirements_general.txt --log ${ROOTDIR}/pip_install.log ;\
