#!/bin/bash

list_ip_nodes=(ip1 ip2 ip3)

for ip-node in ${list_ip_nodes[*]}
do
    ssh -i you-private-key.key user@ip-node 'sudo useradd user_kuber'
    ssh -i you-private-key.key user@ip-node 'echo random-password | sudo passwd user_kuber  --stdin'
    ssh -i you-private-key.key user@ip-node 'sudo usermod -aG wheel user_kuber'
    ssh -i you-private-key.key user@ip-node 'sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config'
    ssh -i you-private-key.key user@ip-node 'sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config'
    ssh -i you-private-key.key user@ip-node "echo 'user_kuber ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/user_kuber"
    ssh -i you-private-key.key user@ip-node "curl -sSL https://get.docker.com/ | sh"
    ssh -i you-private-key.key user@ip-node "sudo systemctl start docker; sudo systemctl enable docker;"
    ssh -i you-private-key.key user@ip-node "curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.rpm.sh | sudo bash"
    ssh -i you-private-key.key user@ip-node "sudo yum install gitlab-ci-multi-runner"
    ssh -i you-private-key.key user@ip-node 'sudo /usr/sbin/reboot'
done
