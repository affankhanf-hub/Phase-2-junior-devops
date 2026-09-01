Objective
Learn Ansible fundamentals: inventory, ad-hoc commands, modules, and playbooks.

📚 Textbook Chapters Studied
Chapter 7 – Ansible Configuration Management

🎯 Theory Summary (In My Own Words)
Ansible is a configuration management tool. Instead of logging into servers and running commands manually, I write a YAML playbook that describes the desired state. Ansible then makes it happen on all servers in the inventory.

Why Ansible Exists:
Problem	Ansible Solution
Manual server setup is slow	Automate with playbooks
Servers drift over time	Enforce desired state
Hard to track changes	Playbooks are version-controlled
🔧 Lab Environment
OS: Ubuntu 22.04 (WSL2)

Shell: Bash

Ansible Version: 2.14.x

📁 Files Created
1. ansible/inventory.ini
ini
[local]
localhost ansible_connection=local
2. ansible/first-playbook.yml
yaml
---
- name: Basic Server Setup
  hosts: local
  become: true

  tasks:
    - name: Ensure nginx is installed
      apt:
        name: nginx
        state: present

    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: true

    - name: Create a test directory
      file:
        path: /tmp/ansible-test
        state: directory
        mode: '0755'

    - name: Create a test file
      copy:
        content: "Hello from Ansible!\n"
        dest: /tmp/ansible-test/hello.txt
🔧 Commands Used
bash
# Install Ansible
sudo apt update
sudo apt install ansible -y

# Ad-hoc commands
ansible -i inventory.ini local -m ping
ansible -i inventory.ini local -m command -a "uptime"
ansible -i inventory.ini local -m shell -a "df -h /"

# Run playbook
ansible-playbook -i inventory.ini first-playbook.yml
📊 Important Output Evidence
Ad-hoc Command Outputs
bash
$ ansible -i inventory.ini local -m ping
localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

$ ansible -i inventory.ini local -m command -a "uptime"
localhost | CHANGED | rc=0 >>
 10:00:00 up 2 days, 3:45, 1 user, load average: 0.23, 0.34, 0.27
Playbook Output
bash
PLAY [Basic Server Setup] ****************************************************

TASK [Gathering Facts] ********************************************************
ok: [local]

TASK [Ensure nginx is installed] **********************************************
changed: [local]

TASK [Ensure nginx is running] ************************************************
changed: [local]

TASK [Create a test directory] ************************************************
changed: [local]

TASK [Create a test file] *****************************************************
changed: [local]

PLAY RECAP ********************************************************************
local                      : ok=5    changed=4    unreachable=0    failed=0
Second Run (Idempotency)
bash
PLAY RECAP ********************************************************************
local                      : ok=5    changed=0    unreachable=0    failed=0
changed=0 → Nothing changed! (Idempotent!)

✅ Validation Result
Check	Result	Status
Ansible installed	✅	PASS
Inventory created	✅	PASS
Ad-hoc commands work	✅	PASS
Playbook runs	✅	PASS
Idempotency demonstrated	✅	PASS
nginx installed	✅	PASS
Test file created	✅	PASS
🐛 Issue & Fix
Issue: Permission Denied
Symptom: sudo: a password is required
Root Cause: Ansible needs sudo privileges to install packages.
Fix: Added become: true to the playbook.

💼 What I Would Check in a Real Job
Is Ansible installed? → ansible --version

Is inventory correct? → ansible -i inventory.ini all --list-hosts

Can Ansible connect? → ansible -i inventory.ini all -m ping

🗣️ 60-Second Interview Answer
"Ansible automates server configuration using YAML playbooks. I define the desired state, and Ansible makes it happen. It's idempotent — running it multiple times doesn't break anything."


