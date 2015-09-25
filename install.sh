echo "Installing EPEL repository in /etc/yum.repos.d/epel*"
rpm -iUvh --quiet \
     http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
echo "Installing Ansible"
yum install -y -q ansible
#sudo yum install --downloadonly --downloaddir=/vagrant/ansible.rpm  ansible
#sudo yum localinstall /vagrant/ansible-rpm/*.rpm -q -y
echo "Copying ansible config files to /etc/ansible/"
cp /etc/ansible/hosts     /etc/ansible/hosts.orig 
cp /vagrant/ansible/*     /etc/ansible/
echo "Done"
