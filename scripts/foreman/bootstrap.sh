#!/usr/bin/env bash

if ps aux | grep "/usr/share/foreman" | grep -v grep 2> /dev/null
then
  echo "Foreman appears to all already be installed. Exiting..."
else
  sudo yum -y update && sudo yum -y upgrade
  sudo yum-config-manager --enable rhel-7-server-optional-rpms rhel-server-rhscl-7-rpms
  sudo gpg --recive-keys 897740e9 897740e9 ef8d349f 352c64e5 4BD6EC30 EF8D349F 8347A27F F4A80EB5 352c64e5
  sudo yum -y install gpg yum-utils wget puppet ansible libvirt-client memcached

  sudo yum -y update && sudo yum -y upgrade
  sudo yum -y install foreman-installer

  sudo systemctl enable memcached
  sudo systemctl start memcached

  sudo foreman-installer --enable-foreman --enable-foreman-cli --enable-foreman-plugin-memcache --enable-foreman-compute-libvirt --enable-foreman-plugin-ansible --enable-foreman-plugin-bootdisk --enable-foreman-plugin-remote-execution --enable-foreman-plugin-tasks --enable-foreman-proxy --enable-puppet

  sudo localectl set-keymap de-latin1-nodeadkeys
  sudo localectl set-locale "de_DE.UTF-8"

  sudo systemctl enable firewalld
  sudo systemctl start firewalld
  sudo firewall-cmd --permanent --add-interface=eth0 --zone=trusted
  sudo firewall-cmd --permanent --zone=trusted --set-target=ACCEPT
  sudo firewall-cmd --permanent --add-interface=eth1 --zone=public
  sudo firewall-cmd --permanent --add-interface=virbr0 --zone=public
  sudo firewall-cmd --permanent --zone=public --set-target=DROP

  sudo firewall-cmd --reload

  sudo firewall-cmd --permanent --add-service=dns # dns server
  sudo firewall-cmd --permanent --add-service=dhcp # dhcp server
  sudo firewall-cmd --permanent --add-service=tftp # dhcp server
  sudo firewall-cmd --permanent --add-service=http # Foreman Web UI
  sudo firewall-cmd --permanent --add-service=https # Foreman Web UI
  sudo firewall-cmd --permanent --add-service=vnc-server # Foreman Web UI
  sudo firewall-cmd --permanent --add-service=puppet-master # Foreman Web UI
  sudo firewall-cmd --permanent --add-port=8443/tcp # Smart Proxy, open only to foreman

  sudo firewall-cmd --reload

  sudo /opt/puppetlabs/bin/puppet agent --test --waitforcert=60
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules puppetlabs-ntp
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules puppetlabs-git
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules puppetlabs-vcsrepo
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules jfryman-nginx
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules puppetlabs-haproxy
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules puppetlabs-apache
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules puppetlabs-java
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules deric/zookeeper
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules puppet/kafka
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules elastic/elasticsearch
  sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppet/environments/production/modules elastic/logstash

  sudo yum -y install qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer dejavu-lgc-sans-fonts xauth

  sudo systemctl enable libvirtd
  sudo systemctl start libvirtd
  sudo usermod -a -G libvirt foreman
  sudo usermod -a -G qemu foreman
  sudo usermod -a -G libvirt vagrant
  sudo usermod -a -G qemu vagrant
  touch ~/.Xauthorityvagrant
  sudo usermod -a -G qemu vagrant
  touch ~/.Xauthority
  sudo systemctl enable httpd
  sudo systemctl start httpd
  sudo systemctl enable foreman-proxy
  sudo systemctl start foreman-proxy
fi