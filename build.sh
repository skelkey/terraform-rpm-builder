#!/bin/bash

fedora28_rsa=$(mktemp /tmp/XXXXXX_fedora28_keypair.rsa)
fedora33_rsa=$(mktemp /tmp/XXXXXX_fedora33_keypair.rsa)

terraform apply --auto-approve

fedora28_ip=$(terraform output --raw fedora28_rpm_builder)
fedora33_ip=$(terraform output --raw fedora33_rpm_builder)

terraform output --raw fedora33_keypair > $fedora33_rsa
terraform output --raw fedora28_keypair > $fedora28_rsa

echo "ssh -i $fedora28_rsa fedora@$fedora28_ip"
echo "ssh -i $fedora33_rsa fedora@$fedora33_ip"
#scp fedora28
#scp fedora33

#terraform destroy --auto-approve
