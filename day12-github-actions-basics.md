📋 Objective
Learn GitHub Actions fundamentals: workflows, jobs, steps, runners, and secrets.

📚 Textbook Chapters Studied
Chapter 8 – GitHub Actions and CI/CD

🎯 Theory Summary (In My Own Words)
What is GitHub Actions?
GitHub Actions is a tool that automatically runs tasks when you push code to GitHub. For example, it can:

✅ Build your Docker image

✅ Run tests

✅ Deploy your application

Why is it called CI/CD?
Term	What It Means
CI (Continuous Integration)	Automatically test code when pushed
CD (Continuous Deployment)	Automatically deploy code when tests pass
What is a Workflow?
A workflow is a YAML file that defines what GitHub Actions should do. It contains:

Jobs → A group of steps

Steps → Individual tasks (e.g., run a command)

Runners → The machine that runs the workflow

🔧 Lab: GitHub Actions Basics
Step 1 – Create Project Directory
bash
cd ~/phase-2-junior-devops
mkdir -p .github/workflows
mkdir -p days/day12
Step 2 – Create a Simple Workflow
bash
cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Show directory
        run: ls -la

      - name: Show date
        run: date

      - name: Show who is running
        run: whoami

      - name: Show success message
        run: echo "✅ Workflow completed successfully!"
EOF
Step 3 – Add Docker Build Step
bash
cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Docker image
        run: |
          docker build -t test-app:1.0 .
          docker images

      - name: Run smoke test
        run: |
          docker run -d --name test -p 8080:80 test-app:1.0
          sleep 3
          curl -s http://localhost:8080 || echo "Container not responding"

      - name: Clean up
        run: |
          docker stop test || true
          docker rm test || true
EOF
Step 4 – Push to GitHub
bash
cd ~/phase-2-junior-devops
git add .
git commit -m "Day 12: GitHub Actions Basics - Add CI workflow"
git push
Step 5 – Check GitHub
Go to: https://github.com/affankhanf-hub/phase-2-junior-devops

Click on the "Actions" tab

You should see your workflow running

Click on it to see the output

📊 Important Concepts
Concept	What It Means
Workflow	YAML file that defines automation
Job	A group of steps (runs on one runner)
Step	An individual task (run command or use action)
Runner	The machine that runs the job
Action	Reusable code (like actions/checkout@v4)
Secret	Hidden value (API keys, passwords)
🗣️ 60-Second Interview Answer
"GitHub Actions automates tasks when I push code. I write a YAML workflow that defines jobs and steps. For example, my workflow builds a Docker image and runs a smoke test. This is called CI/CD — it ensures my code works before it's deployed."


