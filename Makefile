PYTHON = python
MPIEXEC = mpiexec

ROOTDIR=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
CODEDIR=${ROOTDIR}/code
ASDF_DIR= $(HOME)/.asdf
PACKAGES_FILE=${ROOTDIR}/mint_packages.txt
ASDF=asdf
PYTHON=python
PIP=pip
ASDF_BIN := $(ASDF_DIR)/bin/asdf
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
	@if [ ! -d "$(ASDF_DIR)" ]; then \
		echo "Cloning asdf..."; \
		git clone https://github.com/asdf-vm/asdf.git ${ASDF_DIR} --branch v0.14.1;\
		echo '. "$$HOME/.asdf/asdf.sh"' >>${HOME}/.bashrc;\
		echo '. "$$HOME/.asdf/completions/asdf.bash"' >>${HOME}/.bashrc; \
	else \
			echo "asdf already installed at $(ASDF_DIR)"; \
	fi
	

asdf_plugins: $(ASDF_DIR)
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) plugin add python || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) plugin add java || true'

install_packages:
	sudo xargs -a ${PACKAGES_FILE} apt install -y

asdf_install_python: asdf_plugins
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  install python 3.11.9 || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  global python 3.11.9 || true'
	$(PYTHON) -m $(PIP) install --upgrade pip ;\
	$(PYTHON) -m $(PIP) install -r ${ROOTDIR}/requirements_general.txt --log ${ROOTDIR}/pip_install.log ;\
