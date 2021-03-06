#!/usr/bin/env bash

source /tmp/common.sh

log-progress-nl "begin"

log-progress-nl "setting up CentOS-Base repository"
sudo cat >/etc/yum.repos.d/CentOS-Base.repo <<EOL
[base]
name=CentOS-7 - Base
baseurl=http://mirror/centos/7/base/
gpgcheck=1
enabled=1
gpgkey=http://mirror/centos/RPM-GPG-KEY-CentOS-7
#released updates

[update]
name=CentOS-7 - Updates
baseurl=http://mirror/centos/7/updates/
gpgcheck=1
enabled=1
gpgkey=http://mirror/centos/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-7 - Extras
baseurl=http://mirror/centos/7/extras/
gpgcheck=1
enabled=1
gpgkey=http://mirror/centos/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-7 - Plus
baseurl=http://mirror/centos/7/centosplus/
gpgcheck=1
enabled=1
gpgkey=http://mirror/centos/RPM-GPG-KEY-CentOS-7
EOL

log-progress-nl "setting up epel repository"
sudo cat >/etc/yum.repos.d/epel.repo <<EOL
[epel]
name=Extra Packages for Enterprise Linux 7 - x86_64
baseurl=http://mirror/centos/7/epel/
enabled=1
gpgcheck=1
gpgkey=http://mirror/centos/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - x86_64 - Debug
baseurl=http://mirror/centos/7/epel/debug/
gpgkey=http://mirror/centos/RPM-GPG-KEY-EPEL-7
enabled=0
gpgcheck=1

EOL

log-progress-nl "setting up puppetlabs repository"
sudo cat >/etc/yum.repos.d/puppetlabs.repo <<EOL
[puppetlabs-products]
name=Puppet Labs Products El 7 - x86_64
baseurl=http://mirror/puppetlabs/el/7/products/x86_64
gpgkey=http://mirror/puppetlabs/RPM-GPG-KEY-puppetlabs
       http://mirror/puppetlabs/RPM-GPG-KEY-puppet
       http://mirror/puppetlabs/RPM-GPG-KEY-reductive
enabled=1
gpgcheck=1

[puppetlabs-deps]
name=Puppet Labs Dependencies El 7 - x86_64
baseurl=http://mirror/puppetlabs/el/7/dependencies/x86_64
gpgkey=http://mirror/puppetlabs/RPM-GPG-KEY-puppetlabs
       http://mirror/puppetlabs/RPM-GPG-KEY-puppet
       http://mirror/puppetlabs/RPM-GPG-KEY-reductive
enabled=1
gpgcheck=1

[puppetlabs-devel]
name=Puppet Labs Devel El 7 - x86_64
baseurl=http://mirror/puppetlabs/el/7/devel/x86_64
gpgkey=http://mirror/puppetlabs/RPM-GPG-KEY-puppetlabs
       http://mirror/puppetlabs/RPM-GPG-KEY-puppet
       http://mirror/puppetlabs/RPM-GPG-KEY-reductive
enabled=0
gpgcheck=1

#[puppetlabs-pc1]
#name=Puppet Labs PC1 el 7 - x86_64
#baseurl=http://mirror/puppetlabs/el/7/PC1/x86_64
#gpgkey=http://mirror/puppetlabs/RPM-GPG-KEY-puppetlabs
#       http://mirror/puppetlabs/RPM-GPG-KEY-puppet
#       http://mirror/puppetlabs/RPM-GPG-KEY-reductive
#enabled=1
#gpgcheck=1

[puppetlabs-products-source]
name=Puppet Labs Products El 7 - x86_64 - Source
baseurl=http://mirror/puppetlabs/el/7/products/SRPMS
gpgkey=http://mirror/puppetlabs/RPM-GPG-KEY-puppetlabs
       http://mirror/puppetlabs/RPM-GPG-KEY-puppet
       http://mirror/puppetlabs/RPM-GPG-KEY-reductive
failovermethod=priority
enabled=0
gpgcheck=1

[puppetlabs-deps-source]
name=Puppet Labs Source Dependencies El 7 - x86_64 - Source
baseurl=http://mirror/puppetlabs/el/7/dependencies/SRPMS
gpgkey=http://mirror/puppetlabs/RPM-GPG-KEY-puppetlabs
       http://mirror/puppetlabs/RPM-GPG-KEY-puppet
       http://mirror/puppetlabs/RPM-GPG-KEY-reductive
enabled=0
gpgcheck=1

[puppetlabs-devel-source]
name=Puppet Labs Devel El 7 - x86_64 - Source
baseurl=http://mirror/puppetlabs/el/7/devel/SRPMS
gpgkey=http://mirror/puppetlabs/RPM-GPG-KEY-puppetlabs
       http://mirror/puppetlabs/RPM-GPG-KEY-puppet
       http://mirror/puppetlabs/RPM-GPG-KEY-reductive
enabled=0
gpgcheck=1

#[puppetlabs-pc1-source]
#name=Puppet Labs PC1 Repository el 7 - Source
#baseurl=http://yum.puppetlabs.com/el/7/PC1/SRPMS
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs-PC1
#       file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppet-PC1
#failovermethod=priority
#enabled=0
#gpgcheck=1
EOL

log-progress-nl "setting up foreman repository"
sudo cat >/etc/yum.repos.d/foreman.repo <<EOL
[foreman]
name=Foreman 1.16
baseurl=http://mirror/theforeman/releases/1.16/el7/x86_64
enabled=1
gpgcheck=1
gpgkey=http://mirror/theforeman/RPM-GPG-KEY-foreman-1.16

[foreman-source]
name=Foreman 1.16 - source
baseurl=http://mirror/theforeman/releases/1.16/el7/source
enabled=0
gpgcheck=1
gpgkey=http://mirror/theforeman/RPM-GPG-KEY-foreman-1.16
EOL

log-progress-nl "setting up foreman-plugins repository"
sudo cat >/etc/yum.repos.d/foreman-plugins.repo <<EOL
[foreman-plugins]
name=Foreman plugins 1.16
baseurl=http://mirror/theforeman/plugins/1.16/el7/x86_64
enabled=1
gpgcheck=0
gpgkey=http://mirror/theforeman/RPM-GPG-KEY-foreman-1.16

[foreman-plugins-source]
name=Foreman plugins 1.16 - source
baseurl=http://mirror/theforeman/plugins/1.16/el7/source
enabled=0
gpgcheck=1
gpgkey=http://mirror/theforeman/RPM-GPG-KEY-foreman-1.16
EOL

log-progress-nl "done"
