#!/bin/bash

TIMEOUT=5
RPM_PATH=/tmp/rpmbuild/RPMS/x86_64
DEBUG=0
OPTIND=1

usage() {
    echo "Usage: $0 [ -d ]"
    echo "Build a RPM for Fedora 33 and Fedora 28 using terraform on Outscale cloud"
    echo ""
    echo "Options:"
    echo "-d Activate the debug mode"
}

while getopts "h?d" opt; do
    case "$opt" in
        h|\?)
	    usage
	    exit 0
	    ;;
        d)
	    DEBUG=1
	    ;;
    esac
done
shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

fedora28_rsa=$(mktemp /tmp/XXXXXX_fedora28_keypair.rsa)
fedora33_rsa=$(mktemp /tmp/XXXXXX_fedora33_keypair.rsa)

terraform init
terraform apply --auto-approve

fedora28_ip=$(terraform output --raw fedora28_rpm_builder)
fedora33_ip=$(terraform output --raw fedora33_rpm_builder)

terraform output --raw fedora33_keypair > $fedora33_rsa
terraform output --raw fedora28_keypair > $fedora28_rsa

echo "Fedora 28 : ssh -i $fedora28_rsa fedora@$fedora28_ip"
echo "Fedora 33 : ssh -i $fedora33_rsa fedora@$fedora33_ip"

for i in $(seq 1 $TIMEOUT)
do
    echo -e "Try #$i (waiting $i minutes()) ..."
    sleep ${i}m
    if ssh -o "StrictHostKeyChecking no" -i $fedora28_rsa fedora@$fedora28_ip test -e /tmp/done
    then
        scp -o "StrictHostKeyChecking no" -i $fedora28_rsa fedora@$fedora28_ip:$RPM_PATH/*.rpm /tmp
	echo "OK"
        break
    fi
    echo "Failed"
done
if test $i -eq $TIMEOUT
then
    echo "Failed to download RPMS from fedora 28"
fi

for i in $(seq 1 $TIMEOUT)
do
    echo -e "Try #$i (waiting $i minutes()) ..."
    sleep ${i}m
    if ssh -o "StrictHostKeyChecking no" -i $fedora33_rsa fedora@$fedora33_ip test -e /tmp/done
    then
        scp -o "StrictHostKeyChecking no" -i $fedora33_rsa fedora@$fedora33_ip:$RPM_PATH/*.rpm /tmp
	echo "OK"
        break
    fi
    echo "Failed"
done  
if test $i -eq $TIMEOUT
then
    echo "Failed to download RPMS from fedora 33"
fi

if [ $DEBUG = 1 ]; then
    echo "Debug mode activated. Pausing before destruction of instances"
    echo ""
    echo "Press any key to continue ..."
    read -n 1
fi

terraform destroy --auto-approve
rm -f $fedora33_rsa
rm -f $fedora28_rsa
