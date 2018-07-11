INSTALLING ON VIRTUALBOX

#Setting up vagrant-------------------------------------------------------

# To run these please ensure you have the following installed:
# Vagrant 1.9.6 (https://releases.hashicorp.com/vagrant/1.9.6/)
# VirtualBox 5.1.30 (https://www.virtualbox.org/wiki/Download_Old_Builds_5_1)
# Vagrant 2 and VirtualBox 5.2 have some defects.

#If you are behind an HTTP proxy:
export http_proxy=http://user:password@host:port
export https_proxy=https://user:password@host:port
vagrant plugin install vagrant-proxyconf


# For all users: plugins to install
vagrant plugin install vagrant-triggers
vagrant plugin uninstall vagrant-vbguest

#Creating the vagrant box ------------------------------------------------

#All packages are set to be installed on a vagrant box that needs to be created first.
#To create it please do the following:

vagrant up
# this takes several minutes

#If there are any issues, please check the logs by:
vagrant ssh -c 'cat /var/log/vboxadd-install.log'
vagrant ssh -c 'sudo journalctl -r'

# if this is the first time using this box and get an SSL error:
# download manually and install
curl -v -L -o centos.box -k  https://vagrantcloud.com/bento/boxes/centos-7.4/versions/201710.25.0/providers/virtualbox.box
vagrant box add bento/centos-7.2 centos.box

#Suspending and resuming the vagrantbox -----------------------------------

#After working, please stop the vagrant box session (don't forget to save any work!)
vagrant halt
#To start again after the vagrantbox has been created
vagrant up

