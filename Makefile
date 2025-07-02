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
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/numpyT.py"
sklearn: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/sklearnT.py"

matplotlib: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/matplotlibT.py"

keras: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/kerasT.py"

cython: 
	bash -c ". $(ASDF_DIR)/asdf.sh && cd ${CODEDIR} && ${PYTHON} ./cythonSumT.py"

pyopencl: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/pyopenclT.py"

mpi: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${MPIEXEC}	${PYTHON} ${CODEDIR}/mpiT.py"

threads: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/threadsT.py"

joblib: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/threadsT.py"

pyopenclimage: 
	bash -c ". $(ASDF_DIR)/asdf.sh && cd ${CODEDIR} && ${PYTHON} ./imageFillIntT.py "

spark: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/sparkT.py"

tqdm: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/tqdmT.py"

skimage: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/skimageT.py"

opencv: 
	bash -c ". $(ASDF_DIR)/asdf.sh && cd ${CODEDIR} && ${PYTHON} ./opencvT.py"

tensorflow: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/tensorflowT.py"

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
	sudo apt update
	sudo apt upgrade -y
	sudo xargs -a ${PACKAGES_FILE} apt install -y

asdf_install_python: asdf_plugins
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  install python 3.11.9 || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  global python 3.11.9 || true'

python_install_packages: asdf_install_python
	bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m $(PIP) install --upgrade pip "
	bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m $(PIP) install -r ${ROOTDIR}/requirements_general.txt --log ${ROOTDIR}/pip_install.log "
