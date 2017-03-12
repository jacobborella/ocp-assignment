#!/bin/bash
source set_env.sh
domain_name=$(hostname -f|cut -d '.' -f 2-8)
cat /dev/zero | ssh-keygen -q -N ""
sudo subscription-manager register --username $sub_man --password $sub_man_pswd
sudo subscription-manager attach --pool=$pool_id
sudo subscription-manager repos --disable="*"
sudo yum-config-manager --disable \*
sudo subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.4-rpms"
sudo yum install -y atomic-openshift-utils
sudo sed -i -e "s/^# control_path = %(directory)s\/%%h-%%r/control_path = %(directory)s\/%%h-%%r/" /etc/ansible/ansible.cfg
ssh-copy-id -o StrictHostKeyChecking=no master1
ssh master1 "echo 'aMc5re1weaPkg'|sudo -S sed -i -e '$ a\jborella\tALL=(ALL)\tNOPASSWD: ALL' /etc/sudoers"
ssh -o StrictHostKeyChecking=no master1.$domain_name "whoami"

ssh-copy-id -o StrictHostKeyChecking=no master2
ssh master2 "echo 'aMc5re1weaPkg'|sudo -S sed -i -e '$ a\jborella\tALL=(ALL)\tNOPASSWD: ALL' /etc/sudoers"
ssh -o StrictHostKeyChecking=no master2.$domain_name "whoami"

ssh-copy-id -o StrictHostKeyChecking=no master3
ssh master3 "echo 'aMc5re1weaPkg'|sudo -S sed -i -e '$ a\jborella\tALL=(ALL)\tNOPASSWD: ALL' /etc/sudoers"
ssh -o StrictHostKeyChecking=no master3.$domain_name "whoami"


ssh-copy-id -o StrictHostKeyChecking=no infra1
ssh infra1 "echo 'aMc5re1weaPkg'|sudo -S sed -i -e '$ a\jborella\tALL=(ALL)\tNOPASSWD: ALL' /etc/sudoers"
ssh -o StrictHostKeyChecking=no infra1.$domain_name "whoami"

ssh-copy-id -o StrictHostKeyChecking=no infra2
ssh infra2 "echo 'aMc5re1weaPkg'|sudo -S sed -i -e '$ a\jborella\tALL=(ALL)\tNOPASSWD: ALL' /etc/sudoers"
ssh -o StrictHostKeyChecking=no infra2.$domain_name "whoami"

ssh-copy-id -o StrictHostKeyChecking=no app1
ssh app1 "echo 'aMc5re1weaPkg'|sudo -S sed -i -e '$ a\jborella\tALL=(ALL)\tNOPASSWD: ALL' /etc/sudoers"
ssh -o StrictHostKeyChecking=no app1.$domain_name "whoami"

sed -i -e "s/dud11glxmi2edm0cgnwmaovwqf/$domain_name/g" ansible-host-file/hosts

sudo cp ansible-host-file/hosts /etc/ansible/

ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml -f 10
