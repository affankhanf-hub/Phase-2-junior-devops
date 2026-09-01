📋 Objective
Learn to build a Docker image automatically using GitHub Actions.

📚 Textbook Chapters Studied
Chapter 8 – GitHub Actions and CI/CD

🎯 Theory Summary (In My Own Words)
Day 13 builds on Day 12 by adding Docker to the CI pipeline. Instead of just running simple commands, GitHub Actions now builds a Docker image, runs a container, and tests it. This is what real CI/CD pipelines do.

🔧 Lab: Build Docker Image in CI
Step 1 – Create Dockerfile
bash
cd ~/phase-2-junior-devops
cat > Dockerfile << 'EOF'
FROM alpine:latest
CMD echo "Hello from Docker in CI!"
EOF
Step 2 – Create Workflow File
bash
cat > .github/workflows/ci.yml << 'EOF'
name: Docker CI

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker image
        run: docker build -t my-app .

      - name: Show Docker images
        run: docker images

      - name: Run container
        run: docker run my-app
EOF
Step 3 – Push to GitHub
bash
cd ~/phase-2-junior-devops
git add .
git commit -m "Day 13: Build Docker image in CI"
git push
Step 4 – Check GitHub Actions
Go to your repo → Actions tab

You will see the workflow running

Click on it to see the output

📊 Expected Output
text
Checkout code ✅
Build Docker image ✅
  → Step 1/1 : FROM alpine:latest
  → Successfully built abc123
  → Successfully tagged my-app:latest
Show Docker images ✅
  → REPOSITORY   TAG       IMAGE ID
  → my-app       latest    abc123
Run container ✅
  → Hello from Docker in CI!
🗣️ 60-Second Interview Answer
"GitHub Actions builds Docker images automatically when I push code. This ensures that every commit produces a working image."



