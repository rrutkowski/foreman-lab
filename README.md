**Vagrant setup**

* Install vagrant "(yum install|apt-get install|pacman -Sy) vagrant"

* vagrant plugin install vagrant-libvirt vagrant-share vagrant-ssh

* export VAGRANT_DEFAULT_PROVIDER=libvirt

**Virtualization Host Setup**

* Install firewalld "(yum install|apt-get install|pacman -Sy) firewalld"
```
systemctl enable firewalld
systemctl start firewalld
```

* Remove default interface and setup 3 interfaces for use with the boxes
```
virsh net-destroy default
virsh net-undefine default

virsh net-define boxes/setup/virsh/net-define_adm-lan.xml
virsh net-start adm-lan

virsh net-define boxes/setup/virsh/net-define_prd-lan.xml
virsh net-start prd-lan

virsh net-define boxes/setup/virsh/net-define_dev-lan.xml
virsh net-start dev-lan
```

* Create firewall zones and allow unfiltered access to the bridge interfaces

```
firewall-cmd --permanent --new-zone=adm
firewall-cmd --permanent --new-zone=prd
firewall-cmd --permanent --new-zone=dev
firewall-cmd --permanent --add-interface=virbr0 --zone=adm
firewall-cmd --permanent --add-interface=virbr1 --zone=prd
firewall-cmd --permanent --add-interface=virbr2 --zone=dev
firewall-cmd --permanent --add-interface=wlp2s0 --zone=public
```

* Enable masquerading on public interface and disable firewall on bridged interfaces. We use another firewall on the brdiged hosts.
```
firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -m physdev --physdev-in virbr0 --physdev-is-bridged -j DENY
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -m physdev --physdev-in virbr1 --physdev-is-bridged -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -m physdev --physdev-in virbr2 --physdev-is-bridged -j ACCEPT

firewall-cmd --reload
```


**System Setup**

* For Intel CPU enable nested virtualization and iommu for memory virtualization. In my case this is kvm_intel.nested=1 and kvm_intel.intel.iommu=on.


* Enable forwarding and disable redirects.
```
cat /etc/sysctl.d/10-ip-forward.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.all.send_redirects=0
```

* Import foreman_dev and foreman_prd ca certificates and setup firefox for KVM Console redirection per websocket.
```
about:config
network.websocket.allowInsecureFromHTTPS true
```

* To enable local resolution of dhcp hosts i use dnsmasq and NetworkManager.
```
cat >/etc/NetworkManager/conf.d/localdns.conf <<EOL
[main]
dns=dnsmasq
EOL
```

```
cat >/etc/resolv.conf <<EOL
# Generated by NetworkManager
search guest.oic adm.lan prd.lan dev.lan
nameserver 127.0.0.1
EOL
```

```
cat >/etc/NetworkManager/dnsmasq.d/libvirt.conf <<EOL
server=/adm.lan/192.168.0.1 # resolve throught local kvm server
server=/prd.lan/172.16.10.10 # resolve throught foreman-prd.prd.lan server
server=/dev.lan/172.16.20.20 # resolve throught foreman-dev.dev.lan server
EOL
```

**Setup Mirror Service**
```
cd boxes/mirror
vagrant up
vagrant ssh
```
/root/sync-mirror.sh
currently the gpg keys are not syncing - wget them manually

**Setup Foreman Service (prd/dev)**
```
cd boxes/foreman
vagrant up
vagrant ssh foreman_dev
vagrant ssh foreman_prd
```
During the setup process the admin password and the ca root certificate for prd and dev is printed. You need the root ca certificate to allow kvm console to work throught websockets. For Firefox you also have to set:
```
about:config
network.websocket.allowInsecureFromHTTPS true
```

https://wiki.archlinux.org/index.php/Vagrant

