MPIEXEC := mpiexec

ROOTDIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
CODEDIR := $(ROOTDIR)/code
ASDF_DIR := $(HOME)/.asdf
ASDF_BIN := $(ASDF_DIR)/bin/asdf
PACKAGES_FILE := $(ROOTDIR)/mint_packages.txt
PYTHON := python
PIP := pip

VENV_NAME := sysoai_venv
VENV_DIR := $(HOME)/$(VENV_NAME)
VENV_PYTHON := $(VENV_DIR)/bin/python
VENV_PIP := $(VENV_DIR)/bin/pip

OCLGRIND_REPO := https://github.com/jrprice/Oclgrind.git
OCLGRIND_DIR := Oclgrind
CLANG_VERSION := 20
LLVM_ROOT := /usr/lib/llvm-$(CLANG_VERSION)
CLANG_ROOT := /usr/lib/clang/$(CLANG_VERSION)
CC := clang-$(CLANG_VERSION)
CXX := clang++-$(CLANG_VERSION)

VSCODIUM_KEY := /usr/share/keyrings/vscodium.gpg
VSCODIUM_REPO := /etc/apt/sources.list.d/vscodium.list

.PHONY: all install tests \
	numpy sklearn matplotlib keras cython pyopencl mpi threads joblib ray dask \
	torch pyopenclimage spark tqdm skimage opencv tensorflow jax numba\
	git asdf_plugins update_packages install_packages \
	asdf_install_python create_venv python_install_packages \
	python_install_standalone python_install_standalone2 \
	oclgrind oclgrind-icd vscodium

all: install tests

tests: numpy sklearn matplotlib keras cython pyopencl mpi threads joblib ray dask pyopenclimage spark tqdm skimage opencv torch jax numba

install: asdf_install_python python_install_packages oclgrind-icd vscodium

numpy:
	$(VENV_PYTHON) $(CODEDIR)/numpyT.py

sklearn:
	$(VENV_PYTHON) $(CODEDIR)/sklearnT.py

matplotlib:
	$(VENV_PYTHON) $(CODEDIR)/matplotlibT.py

keras:
	$(VENV_PYTHON) $(CODEDIR)/kerasT.py

cython:
	cd $(CODEDIR) && $(VENV_PYTHON) ./cythonSumT.py

numba:
	cd $(CODEDIR) && $(VENV_PYTHON) ./numbaT.py

pyopencl:
	$(VENV_PYTHON) $(CODEDIR)/pyopenclT.py
	$(VENV_PYTHON) $(CODEDIR)/pyopencl2T.py

mpi:
	$(MPIEXEC) $(VENV_PYTHON) $(CODEDIR)/mpiT.py

threads:
	$(VENV_PYTHON) $(CODEDIR)/threadsT.py

joblib:
	$(VENV_PYTHON) $(CODEDIR)/joblibT.py

ray:
	$(VENV_PYTHON) $(CODEDIR)/rayT.py

dask:
	$(VENV_PYTHON) $(CODEDIR)/daskT.py

torch:
	$(VENV_PYTHON) $(CODEDIR)/torchT.py

pyopenclimage:
	cd $(CODEDIR) && $(VENV_PYTHON) ./imageFillIntT.py

spark:
	$(VENV_PYTHON) $(CODEDIR)/sparkT.py

tqdm:
	$(VENV_PYTHON) $(CODEDIR)/tqdmT.py

skimage:
	$(VENV_PYTHON) $(CODEDIR)/skimageT.py

opencv:
	cd $(CODEDIR) && $(VENV_PYTHON) ./opencvT.py

tensorflow:
	$(VENV_PYTHON) $(CODEDIR)/tensorflowT.py
	$(VENV_PYTHON) $(CODEDIR)/tensorflow2T.py

jax:
	$(VENV_PYTHON) $(CODEDIR)/jaxT.py

git:
	sudo apt install -y git

$(ASDF_DIR): install_packages
	@if [ ! -d "$(ASDF_DIR)" ]; then \
		echo "Cloning asdf..."; \
		git clone https://github.com/asdf-vm/asdf.git $(ASDF_DIR) --branch v0.14.1; \
		echo '. "$$HOME/.asdf/asdf.sh"' >> $(HOME)/.bashrc; \
		echo '. "$$HOME/.asdf/completions/asdf.bash"' >> $(HOME)/.bashrc; \
	else \
		echo "asdf already installed at $(ASDF_DIR)"; \
	fi
	

asdf_plugins: $(ASDF_DIR)
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) plugin add python || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) plugin add java || true'

update_packages:
	sudo apt update
	sudo apt upgrade -y

install_packages: update_packages
	sudo xargs -a $(PACKAGES_FILE) apt install -y

asdf_install_python: asdf_plugins
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) install python 3.13.14 || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) install python 3.13.14t || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) global python 3.13.14 || true'

create_venv: asdf_install_python
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "Creating venv at $(VENV_DIR)..."; \
		bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m venv $(VENV_DIR)"; \
	else \
		echo "Venv already exists at $(VENV_DIR)"; \
	fi

python_install_packages: create_venv
	$(VENV_PIP) install --upgrade pip
	$(VENV_PIP) install -r $(ROOTDIR)/requirements_general.txt --log $(ROOTDIR)/pip_install.log

python_install_standalone:
	bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m $(PIP) install --upgrade pip"
	bash -c ". $(ASDF_DIR)/asdf.sh && $(PYTHON) -m $(PIP) install -r $(ROOTDIR)/requirements_general.txt --log $(ROOTDIR)/pip_install_standalone.log"

python_install_standalone2:
	$(PYTHON) -m $(PIP) install --upgrade pip
	$(PYTHON) -m $(PIP) install -r $(ROOTDIR)/requirements_general.txt --log $(ROOTDIR)/pip_install_standalone.log

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
		CC=$(CC) CXX=$(CXX) cmake .. \
			-DCMAKE_BUILD_TYPE=RelWithDebInfo \
			-DLLVM_DIR=$(LLVM_ROOT)/cmake \
			-DCLANG_ROOT=$(CLANG_ROOT); \
		$(MAKE) VERBOSE=1 -C $(OCLGRIND_DIR)/build -j$$(nproc); \
		$(MAKE) -C $(OCLGRIND_DIR)/build test; \
		sudo $(MAKE) -C $(OCLGRIND_DIR)/build install; \
		sudo ldconfig; \
	fi

oclgrind-icd: oclgrind
	@if [ -f /etc/OpenCL/vendors/oclgrind.icd ]; then \
		echo "Oclgrind ICD already installed at /etc/OpenCL/vendors/oclgrind.icd"; \
	else \
		OCLGRIND_RT=$$(find /usr /usr/local $$(pwd)/Oclgrind \
			-name "liboclgrind-rt-icd.so*" 2>/dev/null | head -1); \
		if [ -z "$$OCLGRIND_RT" ]; then \
			echo "Error: liboclgrind-rt-icd.so not found."; \
			exit 1; \
		fi; \
		echo "Using Oclgrind ICD runtime: $$OCLGRIND_RT"; \
		sudo mkdir -p /etc/OpenCL/vendors; \
		echo "$$OCLGRIND_RT" | sudo tee /etc/OpenCL/vendors/oclgrind.icd >/dev/null; \
		echo "Installed /etc/OpenCL/vendors/oclgrind.icd"; \
	fi

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
