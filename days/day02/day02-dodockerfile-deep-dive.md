# Day 2 - Dockerfile Deep Dive

## 📋 Objective
Learn Dockerfile best practices, understand layers and caching, and create production-ready Docker images.

## 📚 Textbook Chapters Studied
- Chapter 2 - Docker Foundations (Pages 21-23)
  - Section 2.4: Dockerfile Basics (Deep Dive)
  - Section 2.5: Image Layers and Caching
  - Section 2.6: Dockerfile Best Practices

## 🎯 Theory Summary (In My Own Words)

### What I Learned About Layers:
Each instruction in a Dockerfile creates a layer. Docker caches these layers. If a layer hasn't changed, Docker reuses it - this makes builds much faster!

### The Key Best Practices I Learned:
1. **Use Alpine-based images** - They're much smaller (5MB vs 100MB for Ubuntu)
2. **Add health checks** - Docker can monitor if my app is actually working
3. **Add labels** - This documents who built it and what version it is
4. **Use .dockerignore** - Excludes unnecessary files, makes builds faster
5. **Order layers correctly** - Put dependencies first, app code last

## 🔧 Lab Environment Used
- OS: Ubuntu 22.04 (WSL2 on Windows)
- Docker Engine: 29.1.3
- Shell: Bash

## 📝 Commands Used

### 1. Build the Optimized Image
```bash
docker build -t optimized-site:1.0 .


