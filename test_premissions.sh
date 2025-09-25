#!/bin/bash
#Test Script: Verify Users, Groups & Premissions
#Author: Gaurav Chile
# set -x
# 
  echo "===TESTING USERS==="
     for user in admin1 staff1 guest1; do
         id $user 2>/dev/null || echo "User $user does not exist!"
     done

  echo  "===TESTING GROUPS==="
    for group in admin staff guest; do
         getent group $group || echo "Group $group does not exist!"
    done

   echo "===TESTING DIRECTORIES==="
     for dir in /project/admin_data /project/staff_data /project/guest_data; do
        if [ -d "$dir" ]; then
                ls -ld $dir
	else           
		echo "Directory $dir missing!"
	fi
     done
     
  LOG_FILE="access_test_full.log"
  echo "===ACCESS TEST===" > "$LOG_FILE"
  date >> "$LOG_FILE"
  echo >> "$LOG_FILE"

# Users and directories
 users=("admin1" "staff1" "guest1")
 dirs=("/project/admin_data" "/project/staff_data" "/project/guest_data")

# 1 Create project directories if missing
 for dir in "${dirs[@]}"; do
     sudo mkdir -p "$dir"
 done

# 2 Set ownership and permissions
 sudo chown admin1:admin /project/admin_data
 sudo chmod 770 /project/admin_data

 sudo chown staff1:staff /project/staff_data
 sudo chmod 770 /project/staff_data

 sudo chown guest1:guest /project/guest_data
 sudo chmod 770 /project/guest_data

 echo "Directories and permissions fixed." | tee -a "$LOG_FILE"

# 3 Run access tests
 for user in "${users[@]}"; do
     echo >> "$LOG_FILE"
     echo "Testing user: $user" | tee -a "$LOG_FILE"
     for dir in "${dirs[@]}"; do
        file="$dir/${user}_test.txt"
        if sudo -u "$user" bash -c "touch '$file'" 2>/dev/null; then
            echo "$user can write in $dir " | tee -a "$LOG_FILE"
        else
            echo "$user cannot write in $dir " | tee -a "$LOG_FILE"
        fi
     done
 done

# 4 Cleanup test files
 sudo rm -f /project/*/*_test.txt
 echo >> "$LOG_FILE"
 echo "Test Complete " | tee -a "$LOG_FILE"

