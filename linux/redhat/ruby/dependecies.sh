epel_repo=/etc/yum.repos.d/epel.repo
epel_testing_repo=/etc/yum.repos.d/epel-testing.repo
function has_epel_repo(){
	if (test -f $epel_repo)
	then
		return 0
	else 
		return 1
	fi	
}
function has_epel_testing_repo(){
	if (test -f $epel_testing_repo)
	then
		return 0
	else
		return 1
	fi
}
function install_epel_repo(){
	if (has_epel_repo && has_epel_testing_repo)
	then
		echo "epel repo is already installed"
	else
		echo "installing epel repo"
		rpm -ivh http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	fi
}
install_epel_repo
yum -y install libyaml sudo tree
curl -L https://get.rvm.io | bash -s stable --autolibs=3 --ruby=1.9.3
source /usr/local/rvm/scripts/rvm
