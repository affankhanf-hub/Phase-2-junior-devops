📋 Objective
Deploy a fully configured web server with a custom website using Ansible playbooks, handlers, and templates.

📚 Textbook Chapters Studied
Chapter 7 – Ansible Configuration Management

Section 7.4: Playbook

Section 7.6: Handlers

Section 7.7: Templates

🎯 Theory Summary (In My Own Words)
What's New in Day 11:
Concept	What It Means
Handlers	Run a task ONLY IF something changes (e.g., restart nginx if config changes)
Templates	Dynamic config files with variables
Multiple tasks	Install, configure, deploy, restart
🔧 Lab Environment
OS: Ubuntu 22.04 (WSL2)

Shell: Bash

Ansible Version: 2.14.x

📁 Files Created
1. ansible-web/inventory.ini
ini
[local]
localhost ansible_connection=local
2. ansible-web/index.html
html
<!DOCTYPE html>
<html>
<head>
    <title>My Ansible Site</title>
</head>
<body>
    <h1>🚀 Deployed with Ansible!</h1>
    <p>This website was installed automatically.</p>
</body>
</html>
3. ansible-web/webserver.yml (With Handler)
yaml
---
- name: Deploy web server with handler
  hosts: local
  become: true

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Copy nginx config
      copy:
        content: |
          server {
              listen 80;
              server_name localhost;
              root /var/www/html;
              index index.html;
          }
        dest: /etc/nginx/sites-available/default
      notify: Restart nginx

    - name: Deploy website files
      copy:
        src: index.html
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'

    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: true

    - name: Show success message
      debug:
        msg: "✅ Web server deployed at http://localhost"

  handlers:
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
4. ansible-web/templates/index.html.j2 (Template)
html
<!DOCTYPE html>
<html>
<head>
    <title>{{ server_name }}</title>
</head>
<body>
    <h1>🚀 {{ heading }}</h1>
    <p>{{ message }}</p>
    <p><small>Deployed by Ansible on {{ ansible_date_time.date }}</small></p>
</body>
</html>
5. ansible-web/webserver-template.yml (With Template)
yaml
---
- name: Deploy web server with template
  hosts: local
  become: true

  vars:
    server_name: "My Ansible Site"
    heading: "Welcome to My Website"
    message: "This site was deployed using Ansible templates."

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Deploy website from template
      template:
        src: templates/index.html.j2
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'

    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: true

    - name: Show success message
      debug:
        msg: "✅ Web server with template is live!"
🔧 Commands Used (Practical Lab)
bash
# Step 1: Create project directory
cd ~/phase-2-junior-devops
mkdir -p ansible-web
mkdir -p days/day11
cd ansible-web

# Step 2: Create inventory
cat > inventory.ini << 'EOF'
[local]
localhost ansible_connection=local
EOF

# Step 3: Create HTML file
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>My Ansible Site</title>
</head>
<body>
    <h1>🚀 Deployed with Ansible!</h1>
    <p>This website was installed automatically.</p>
</body>
</html>
EOF

# Step 4: Create playbook with handler
cat > webserver.yml << 'EOF'
[content from above]
EOF

# Step 5: Run playbook
ansible-playbook -i inventory.ini webserver.yml -K

# Step 6: Verify in browser
curl http://localhost

# Step 7: Create template
mkdir -p templates
cat > templates/index.html.j2 << 'EOF'
[content from above]
EOF

# Step 8: Create template playbook
cat > webserver-template.yml << 'EOF'
[content from above]
EOF

# Step 9: Run template playbook
ansible-playbook -i inventory.ini webserver-template.yml -K

# Step 10: Verify template in browser
curl http://localhost
📊 Important Output Evidence
Playbook Output (Handler)
bash
PLAY [Deploy web server with handler] *****************************************

TASK [Gathering Facts] ********************************************************
ok: [local]

TASK [Install nginx] **********************************************************
changed: [local]

TASK [Copy nginx config] ******************************************************
changed: [local]

TASK [Deploy website files] ***************************************************
changed: [local]

TASK [Ensure nginx is running] ************************************************
changed: [local]

TASK [Show success message] ***************************************************
ok: [local] => {
    "msg": "✅ Web server deployed at http://localhost"
}

PLAY RECAP ********************************************************************
local                      : ok=6    changed=4    unreachable=0    failed=0
Browser Verification
bash
$ curl http://localhost
<!DOCTYPE html>
<html>
<head>
    <title>My Ansible Site</title>
</head>
<body>
    <h1>🚀 Deployed with Ansible!</h1>
    <p>This website was installed automatically.</p>
</body>
</html>
Template Playbook Output
bash
PLAY [Deploy web server with template] ****************************************

TASK [Gathering Facts] ********************************************************
ok: [local]

TASK [Install nginx] **********************************************************
changed: [local]

TASK [Deploy website from template] *******************************************
changed: [local]

TASK [Ensure nginx is running] ************************************************
changed: [local]

TASK [Show success message] ***************************************************
ok: [local] => {
    "msg": "✅ Web server with template is live!"
}

PLAY RECAP ********************************************************************
local                      : ok=5    changed=3    unreachable=0    failed=0
Template Verification
bash
$ curl http://localhost
<!DOCTYPE html>
<html>
<head>
    <title>My Ansible Site</title>
</head>
<body>
    <h1>🚀 Welcome to My Website</h1>
    <p>This site was deployed using Ansible templates.</p>
    <p><small>Deployed by Ansible on 2026-09-01</small></p>
</body>
</html>
✅ Validation Result
Check	Result	Status
Ansible installed	✅	PASS
Inventory created	✅	PASS
Playbook with handler runs	✅	PASS
Website deployed (curl)	✅	PASS
Template created	✅	PASS
Template playbook runs	✅	PASS
Template deployed (curl)	✅	PASS
🐛 Issue & Fix
Issue: Permission Denied
Symptom: sudo: a password is required
Root Cause: Ansible needs sudo privileges.
Fix: Added become: true to the playbook and used -K flag.

💼 What I Would Check in a Real Job
Is nginx installed? → sudo systemctl status nginx

Is the website accessible? → curl http://localhost

Is the config correct? → sudo nginx -t

Are logs clean? → sudo tail -f /var/log/nginx/error.log

🗣️ 60-Second Interview Answer
"I used Ansible to deploy a complete web server. My playbook installs nginx, copies website files, and ensures the service is running. I added a handler that restarts nginx automatically when the configuration changes. I also used templates to generate dynamic HTML pages with variables."

✅ Lessons Learned
Handlers run only when notified

Templates make configs dynamic

Idempotency ensures safe re-runs

become: true enables sudo

📂 Files Created Today
File	Location
inventory.ini	ansible-web/inventory.ini
index.html	ansible-web/index.html
webserver.yml	ansible-web/webserver.yml
templates/index.html.j2	ansible-web/templates/index.html.j2
webserver-template.yml	ansible-web/webserver-template.yml

