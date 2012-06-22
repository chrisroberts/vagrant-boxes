yum -y install curl

curl -L http://www.opscode.com/chef/install.sh | sudo bash
echo 'PATH=$PATH:/opt/chef/bin'> /etc/profile.d/omnibus_chef.sh
