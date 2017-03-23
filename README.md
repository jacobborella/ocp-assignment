This is my assignment for ocp bootcamp

Before running setup of workstation, give sudo right to jborella user.



Beslutninger:
Beskrivelse af:
* topologi og bevæggrunde herfor.
* opsætning af storage og motivation af valg
* rutning (wildcard DNS collectalot.org, der peger på router)
* fravalgt opsætning af certs a økonomiske årsager
** angiv metoden hertil (openshift_master_named_certificates i https://docs.openshift.com/container-platform/3.4/install_config/install/advanced_install.html)
* opsætning af metrics
** metode b (external nfs host til at gemme records)
** Brugte http://www.tecmint.com/how-to-setup-nfs-server-in-linux/ til opsætning af nfs server (betragter opsætning af nfs out of scope)
** valgte cluster_method=native Hvorfor?
Antagelser:
* maskiner er sat op med ssh adgang og passwordless sudo (krav for ansible kan køre, del af host prep)
** ssh-copy-id master1
** visudo (slutning af linien tilføj jborella	ALL=(ALL)	NOPASSWD: ALL

Udelod sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16"' \
/etc/sysconfig/docker fordi jeg anvender advanced installer, som retter dette automatisk


hosts fil (se https://docs.openshift.com/container-platform/3.4/install_config/install/advanced_install.html#configuring-node-host-labels)






[OSEv3:vars]
#erstat med en allowall
openshift_master_identity_providers=[{'name': 'htpasswd_auth',
'login': 'true', 'challenge': 'true',
'kind': 'HTPasswdPasswordIdentityProvider',
'filename': '/etc/origin/master/htpasswd'}]

#opsæt metrics
openshift_hosted_metrics_deploy=true


[masters]
master1

[nodes]
master1 openshift_node_labels="{'region':'infra','zone':'default'}" openshift_schedulable=false
node1 openshift_node_labels="{'region':'infra','zone':'default'}"
