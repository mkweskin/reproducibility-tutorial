# Automated install of dependencies for Tourmaline: https://github.com/lukenoaa/tourmaline
# Note: this is for lukenoaa's fork of tourmaline 

###
# Conda setup
###

# Test if conda is already installed, if not, install it.
if [ -z `which conda` ]; then
	echo "Installing miniconda 3..."
	# Download and install
	cd ~
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	sh Miniconda3-latest-Linux-x86_64.sh -b

	# Initialize conda
	source ~/.bashrc
	eval "$(conda shell.bash hook)"
else
	echo "Miniconda appears to already be installed, continuing with setup"
	# setup conda for the environment
	eval "$(conda shell.bash hook)"
fi

# Double check that Conda is now available
if [ -z `which conda` ]; then
	echo "There was an issue with the conda install. Please try closing the terminal session and reopening and re-running this script."
	exit 1
fi

# Setup bioconda and conda-forge channels 
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge


# Install qiime2
# TODO: Test if QIIME2 is already
QIIMEVER=2020.8
echo "Installing qiime2 release ${QIIMEVER} as qiime2-${QIIMEVER}"
cd ~
wget https://data.qiime2.org/distro/core/qiime2-${QIIMEVER}-py36-linux-conda.yml
conda env create -n qiime2-${QIIMEVER} --file qiime2-${QIIMEVER}-py36-linux-conda.yml
conda activate qiime2-${QIIMEVER}

# TODO: add a check that the qiime2 env is activated (possibly use `which python` and check the path)

# Install other dependencies
conda install -y snakemake biopython tabulate pandoc tabview bioconductor-msa bioconductor-odseq zip unzip
pip install git+https://github.com/biocore/empress.git

# Clone the tourmaline repo into ~
cd ~
git clone https://github.com/lukenoaa/tourmaline.git

echo "Tourmaline's dependecies have been installed in the 'qiime2-${QIIMEVER}' conda environment'"
echo "That environment is active, to reactivate when you reopen the terminal, use:"
echo "   conda activate qiime2-${QIIMEVER}"

echo "The tourmaline scripts have been installed in $PWD/tourmaline"
