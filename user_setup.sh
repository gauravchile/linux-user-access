#!/bin/bash	
# set -x
## Mini-Project: User & Permission Management
## Author: Gaurav Chile

## === Create groups ===
 sudo groupadd admin
 sudo groupadd staff
 sudo groupadd guest

## === Create users and assign them to groups ===
 sudo useradd -m -s /bin/bash admin1 -G admin
 sudo useradd -m -s /bin/bash staff1 -G staff
 sudo useradd -m -s /bin/bash guest1 -G guest

## === Set passwords for users ===
 echo "admin1:Admin@123" | sudo chpasswd
 echo "staff1:Staff@123" | sudo chpasswd
 echo "guest1:Guest@123" | sudo chpasswd
#
## === Create project directories ===
 sudo mkdir -p /project/admin_data /project/staff_data /project/guest_data
#
## === Set ownership ===
 sudo chown admin1:admin /project/admin_data
 sudo chown staff1:staff /project/staff_data
 sudo chown guest1:guest /project/guest_data
#
## === Set permissions ===
 sudo chmod 770 /project/admin_data
 sudo chmod 770 /project/guest_data
 sudo chmod 7770 /project/staff_data

## === Verification ===
 echo "==== Permission Check ===="
 ls -ld /project/*

 echo "==== Users and Groups ===="
 getent group admin staff guest
