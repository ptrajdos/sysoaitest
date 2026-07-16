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

OCLGRIND_REPO := https://github.com/jrprice/Oclgrind.git
OCLGRIND_DIR := Oclgrind
CLANG_VERSION=20
LLVM_ROOT := /usr/lib/llvm-${CLANG_VERSION}
CLANG_ROOT := "/usr/lib/clang/${CLANG_VERSION}"
CC=clang-${CLANG_VERSION}
CXX=clang++-${CLANG_VERSION}

VSCODIUM_KEY=/usr/share/keyrings/vscodium.gpg
VSCODIUM_REPO=/etc/apt/sources.list.d/vscodium.list

.PHONY: all

all: install tests

tests: numpy sklearn matplotlib keras cython pyopencl mpi threads joblib ray dask  pyopenclimage spark tqdm skimage opencv torch jax

install: asdf_install_python python_install_packages oclgrind-icd


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
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/pyopencl2T.py"

mpi: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${MPIEXEC}	${PYTHON} ${CODEDIR}/mpiT.py"

threads: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/threadsT.py"

joblib: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/joblibT.py"

ray: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/rayT.py"

dask: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/daskT.py"

torch: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/torchT.py"

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
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/tensorflow2T.py"

jax: 
	bash -c ". $(ASDF_DIR)/asdf.sh && ${PYTHON} ${CODEDIR}/jaxT.py"

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
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  install python 3.13.14 || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  install python 3.13.14t || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  global python 3.13.14 || true'

python_install_packages: asdf_install_python
	bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m $(PIP) install --upgrade pip "
	bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m $(PIP) install -r ${ROOTDIR}/requirements_general.txt --log ${ROOTDIR}/pip_install.log "

python_install_standalone:
	bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m $(PIP) install --upgrade pip "
	bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m $(PIP) install -r ${ROOTDIR}/requirements_general.txt --log ${ROOTDIR}/pip_install_standalone.log "

python_install_standalone2:
	$(PYTHON) -m $(PIP) install --upgrade pip
	$(PYTHON) -m $(PIP) install -r ${ROOTDIR}/requirements_general.txt --log ${ROOTDIR}/pip_install_standalone.log

oclgrind: install_packages
	@if command -v oclgrind >/dev/null 2>&1; then \
		echo "Oclgrind already installed."; \
	else \
		if [ ! -d "$(OCLGRIND_DIR)" ]; then \
			git clone $(OCLGRIND_REPO); \
		fi; \
		cd $(OCLGRIND_DIR) && \
		if ! grep -q "exepath\[len\] = '\\0';" src/runtime/oclgrind.cpp; then \
			patch -p1 < ../oclgrind_readlink_fix.patch; \
		fi; \
		mkdir -p $(OCLGRIND_DIR)/build; \
		cd $(OCLGRIND_DIR)/build && \
		CC=${CC} CXX=${CXX} cmake .. \
			-DCMAKE_BUILD_TYPE=RelWithDebInfo \
			-DLLVM_DIR=$(LLVM_ROOT)/cmake \
			-DCLANG_ROOT=$(CLANG_ROOT); \
		$(MAKE) VERBOSE=1 -C $(OCLGRIND_DIR)/build -j$(shell nproc); \
		$(MAKE) -C $(OCLGRIND_DIR)/build test; \
		sudo $(MAKE) -C $(OCLGRIND_DIR)/build install; \
	fi

oclgrind-icd: oclgrind
	@OCLGRIND_RT=$$(ldconfig -p 2>/dev/null | awk '/liboclgrind-rt-icd\.so/{print $$NF; exit}'); \
	if [ -z "$$OCLGRIND_RT" ]; then \
		echo "Error: liboclgrind-rt-icd.so not found after Oclgrind installation."; \
		exit 1; \
	fi; \
	echo "Using Oclgrind ICD runtime: $$OCLGRIND_RT"; \
	sudo mkdir -p /etc/OpenCL/vendors; \
	echo "$$OCLGRIND_RT" | sudo tee /etc/OpenCL/vendors/oclgrind.icd >/dev/null; \
	echo "Installed /etc/OpenCL/vendors/oclgrind.icd"

vscodium:
	@if ! command -v codium >/dev/null 2>&1; then \
		echo "Installing VSCodium..."; \
		sudo apt update; \
		sudo apt install -y curl gpg; \
		if [ ! -f $(VSCODIUM_KEY) ]; then \
			curl -fsSL https://repo.vscodium.dev/vscodium.gpg \
			| gpg --dearmor \
			| sudo tee $(VSCODIUM_KEY) > /dev/null; \
		fi; \
		if [ ! -f $(VSCODIUM_REPO) ]; then \
			sudo curl --output-dir /etc/apt/sources.list.d -LO https://repo.vscodium.dev/vscodium.list; \
		fi; \
		sudo apt update; \
		sudo apt install -y codium; \
	else \
		echo "VSCodium already installed."; \
	fi
