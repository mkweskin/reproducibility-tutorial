# Automated install of dependencies for Tourmaline: https://github.com/lukenoaa/tourmaline
# Note: this is for lukenoaa's fork of tourmaline 
# This should run as a standard user, not as root.
# TODO: check that it's not running as root

# These are used for adding color to output messages:
GREEN="\e[32m"
RED="\e[31m"
PLAIN="\e[0m"

###
# Conda setup
###

# Test if conda is already installed, if not, install it.
if [ -z `which conda` ]; then
	echo -e "${GREEN}Installing miniconda 3...${PLAIN}"
	# Download and install
	cd ~
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	sh Miniconda3-latest-Linux-x86_64.sh -b

	# Initialize conda
	~/miniconda3/bin/conda init
else
	echo -e "${GREEN}Miniconda appears to already be installed, continuing with setup${PLAIN}"
fi

eval "$(~/miniconda3/bin/conda shell.bash hook)"

# Double check that Conda is now available
if [ -z `which conda` ]; then
	echo -e "${RED}There was an issue with the conda install. Please try closing the terminal session and reopening and re-running this script.${PLAIN}"
	exit 1
fi

echo -e "${GREEN}Setting up bioconda channels...${PLAIN}"
# Setup bioconda and conda-forge channels 
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge


# Install qiime2
# TODO: Test if QIIME2 is already
QIIMEVER=2020.8
echo -e "${GREEN}Installing qiime2 release ${QIIMEVER} as qiime2-${QIIMEVER}${PLAIN}"
cd ~
wget https://data.qiime2.org/distro/core/qiime2-${QIIMEVER}-py36-linux-conda.yml
conda env create -n qiime2-${QIIMEVER} --file qiime2-${QIIMEVER}-py36-linux-conda.yml
conda activate qiime2-${QIIMEVER}

# TODO: add a check that the qiime2 env is activated (possibly use `which python` and check the path)
if [ ! ${CONDA_DEFAULT_ENV} = "qiime2-${QIIMEVER}" ]; then
   echo -e "${RED}There was a problem activating the \"qiime2-${QIIMEVER}\" conda environment${PLAIN}"
   echo -e "${RED}This script can't continue, sorry."
   exit 1
fi

# Install other dependencies
conda install -y snakemake biopython tabulate pandoc tabview bioconductor-msa bioconductor-odseq zip unzip
pip install git+https://github.com/biocore/empress.git

# Clone the tourmaline repo into ~
cd ~
git clone https://github.com/lukenoaa/tourmaline.git

echo -e "${GREEN}Tourmaline's dependecies have been installed in the 'qiime2-${QIIMEVER}' conda environment'${PLAIN}"
echo -e "${GREEN}That environment is active, to reactivate when you reopen the terminal, use:${PLAIN}"
echo -e "${GREEN}   conda activate qiime2-${QIIMEVER}${PLAIN}"

echo -e "${GREEN}The tourmaline scripts have been installed in $PWD/tourmaline.${PLAIN}"
