# Run from Vagrantfile the first time a VM is provisioned.
# To run again, you must do vagrant destroy
username=${1:-vagrant}
 
echo `pwd` 

# faster installations of updates
yum install -y deltarpm

# operating system dependencies for virtualbox additions 
# Note do not yum update -y 
yum install -y kernel-headers gcc 
# note that dkms, often recommended for virtualbox, is unsstable in Centos

# could mount iso and
# cd /media/VirtualBoxGuestAdditions
# ./VBoxLinuxAdditions.run

# requirements for rdkit.Chem
yum install -y libXrender libXext

# requirement for pydot
yum install -y graphviz

# requirement for Miniconda
yum install -y bzip2

# requirement for Theano
#yum install -y gcc-c++ epel-release
#yum install -y openblas

#Install miniconda 
for i in 1 2 3 4 5; do
        wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && break
        sleep 15
        echo 'Retrying bash download'
done

bash Miniconda3-latest-Linux-x86_64.sh -b

#bash Miniconda3-latest-Linux-x86_64.sh <<HERE1
#yes
#\r
#\r
#yes
#miniconda3
#no
#HERE1

export PATH=$HOME/miniconda3/bin:$PATH

# import the Python dependencies
for i in 1 2 3 4 5; do
	$HOME/miniconda3/bin/conda env update -q -f environment.yml -n root && break
	sleep 15
	echo 'Retrying conda env create'
done

echo 'Please wait...'


# config for jupyter
# note that the port is open
# the host machine is responsible for firewalling.
mkdir /etc/jupyter/
cat > /etc/jupyter/jupyter_notebook_config.py <<HERE
c.NotebookApp.ip = '*'
c.NotebookApp.notebook_dir = '`pwd`' 
c.NotebookApp.token = u''
HERE
# TODO see http://stuartmumford.uk/blog/jupyter-notebook-and-conda.html 

# enable jupyter
cat > /usr/lib/systemd/system/jupyter.service <<HERE0
[Unit]
Description=jupyter

[Service]
Type=simple
Environment="PATH=$HOME/miniconda3/bin:/usr/local/bin:/usr/bin"
PIDFile=/var/run/jupyter.pid
User=$username
ExecStart=$HOME/miniconda3/bin/jupyter notebook --no-browser
ExecStop=/usr/bin/pkill -f jupyter-notebook
# or ExecStop=kill $(pidof /e2e/bin/qa-jupyter-notebook-service-start) 
WorkingDirectory=`pwd`

[Install]
WantedBy=multi-user.target
HERE0

# TODO ln -s '/usr/lib/systemd/system/ipython-notebook.service' '/etc/systemd/system/multi-user.target.wants/ipython-notebook.service'

echo 'Starting Jupyter...'

systemctl daemon-reload
systemctl enable jupyter

# also done as a trigger after up
systemctl start jupyter
echo 'Please visit http://127.0.0.1:8888/notebooks/Welcome.ipynb'


# allow traverse to ananconda folder
chmod a+x /root
echo 'export PATH=$PATH:$HOME/miniconda3/bin/' >> ../.bashrc
echo 'source activate root' >> ../.bashrc
# jupyter will use root environment when started by systemd
