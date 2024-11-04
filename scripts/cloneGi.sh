#!/bin/bash

LOG_FILE="/var/log/script_execution.log"

# Function to check the exit status of the last executed command
check_exit_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed." | tee -a $LOG_FILE
        exit 1
    else
        echo "$1 succeeded." | tee -a $LOG_FILE
    fi
}



# Create the  Ansible playbook for cloning the private GitHub repo
echo "Creating Ansible playbook to clone private GitHub repo and run a script..." | tee -a $LOG_FILE
sudo tee /media/ansible/getApp.yaml > /dev/null <<EOF
- name: Clone private GitHub repo and run a script
  hosts: example
  become: yes
  tasks:

    - name: Ensure Git is installed
      apt:
        name: git
        state: present
      when: ansible_os_family == "Debian"

    - name: Clone private repository using HTTPS
      git:
        repo: ""
        dest: "/media/myapp"
        version: main
        force: yes
EOF
check_exit_status "Create Ansible playbook for cloning GitHub repo"

# Navigate to the Ansible directory
echo "Navigating to Ansible directory..." | tee -a $LOG_FILE
cd /media/ansible
check_exit_status "Change directory to /media/ansible"

# Run the Github Ansible playbook
echo "Running the playbook to push the application..." | tee -a $LOG_FILE
sudo ansible-playbook -i /media/ansible/inventory -u ubuntu /media/ansible/getApp.yaml
check_exit_status "Run Ansible playbook to clone GitHub repo and run script"


