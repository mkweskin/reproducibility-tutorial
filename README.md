# reproducibility-tutorial
For FOSS 2020

## Computer setup

```
# Clone repo
cd /scratch/
sudo git clone https://github.com/mkweskin/reproducibility-tutorial.git
sudo chown -R `whoami` reproducibility-tutorial

# Install miniconda into my home
cd ~
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh
# Choose default location (~/miniconda3) and choose to have environment initiated
#  Then, logout and login to use new ~/.bashrc

# Install jupyter and its components
conda install -c conda-forge -y jupyterlab=1.2.3 nodejs=10.13.0
pip install bash_kernel
pip install ipykernel
python3 -m bash_kernel.install

# Test jupyter install
jupyter lab --no-browser --allow-root --ip=0.0.0.0 --NotebookApp.token='' --NotebookApp.password='' --notebook-dir='/scratch/reproducibility-tutorial/'

# Install snakemake and test
conda install -c bioconda -c conda-forge -y snakemake=5.8.1
snakemake --version

# Install docker (see: https://docs.docker.com/engine/install/ubuntu/)
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# ...and test install
sudo docker run hello-world
```
