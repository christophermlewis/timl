mongodb_repo=/etc/yum.repos.d/10gen.repo

function install_10gen_repo {
  if (test -f $mongodb_repo)
  then 
    echo "10gen repo has been installed."
  else
    repo_content="[10gen]\nname=10gen Repository\nbaseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64\ngpgcheck=0\nenabled=1"
    echo -e $repo_content > $mongodb_repo
  fi
}

function install_mongodb {
  (rpm -qa | grep mongo-10gen) ||  yum -y install mongo-10gen && echo "mongodb has been installed."
  (rpm -qa | grep mongo-10gen-server) || yum -y install mongo-10gen-server && echo "mongodb server has been install."
}

function apply_kernel_params {
l_file=/etc/security/limits.conf
l_input=`grep -c -E "(mongod|mongos)" $l_file`;
if [ "$l_input" -gt "8" ] && [ "$l_input" -ne "8" ] && [ "$l_input" -ne "0" ];
then
   echo "There are entries in the $l_file but not the number we expect, please review it";
elif [ "$l_input" -lt "8" ] && [ "$l_input" -ne "8" ] && [ "$l_input" -ne "0" ];
then
   echo "There are entries in the $l_file but not the number we expect, please review it";
elif [ "$l_input" -eq "0" ];
then
   echo "Kernel limits are not set correctly"
   echo "There are $l_input set"
   echo "Applying now. Please rerun script after completion"
       (echo mongod     soft    nproc     32000;
        echo mongod     hard    nproc     32000;
        echo mongod     soft    nofile    64000;
        echo mongod     hard    nofile    64000;
        echo;
        echo mongos     soft    nproc     32000;
        echo mongos     hard    nproc     32000;
        echo mongos     soft    nofile    64000;
        echo mongos     hard    nofile    64000) >> $l_file
elif [ "$l_input" -eq "8" ];
then
   echo "Kernel limits are set - $l_input in total";
fi
}

function apply_kernel_params_pam {
lp_file=/etc/security/limits.d/90-nproc.conf
lp_input=`grep -c -E "(mongod|mongos)" $lp_file`;
if [ "$lp_input" -gt "2" ] && [ "$lp_input" -ne "2" ] && [ "$lp_input" -ne "0" ];
then
   echo "There are entries in the $lp_file but not the number we expect, please review it";
elif [ "$lp_input" -lt "2" ] && [ "$lp_input" -ne "2" ] && [ "$lp_input" -ne "0" ];
then
   echo "There are entries in the $lp_file but not the number we expect, please review it";
elif [ "$lp_input" -eq "0" ];
then
   echo "Pam Kernel limits are not set correctly"
   echo "There are $lp_input set"
   echo "Applying now. Please rerun script after completion"
       (echo mongod     soft    nproc   32000;
        echo mongos     soft    nproc   32000) >> $lp_file
elif [ "$lp_input" -eq "2" ];
then
   echo "Pam Kernel limits are set - $lp_input in total";
fi
}

install_10gen_repo
install_mongodb
apply_kernel_params
apply_kernel_params_pam


