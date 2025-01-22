#!/bin/bash

# Aenzbi Cloud Suite Automation Script - Expanded

# Functions
function check_tool {
    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found. Please install it."
        exit 1
    fi
}

# Ensure necessary tools are installed
check_tool git
check_tool node
check_tool npm
check_tool docker
check_tool aws
check_tool jq  # For JSON parsing

# Setup Project
echo "Setting up the Aenzbi Cloud Suite project..."
if [ ! -d "aenzbi-cloud" ]; then
    mkdir aenzbi-cloud
    cd aenzbi-cloud || exit
    git init
    echo "Initialized git repository."
else
    echo "Directory 'aenzbi-cloud' already exists. Moving into it."
    cd aenzbi-cloud || exit
fi

# Node.js Project Initialization
echo "Initializing Node.js project..."
npm init -y

# Install dependencies (expanded list)
echo "Installing dependencies..."
npm install react react-dom redux express mongoose mongodb bcryptjs jsonwebtoken dotenv cors

# Setup Docker
echo "Setting up Docker environment..."
cat << EOF > Dockerfile
FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
EOF

# Basic server setup
echo "Creating server.js..."
cat << EOF > server.js
const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

mongoose.connect(process.env.MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => console.log('MongoDB connected...'))
.catch(err => console.log(err));

app.get('/', (req, res) => {
  res.send('Welcome to Aenzbi Cloud!');
});

app.listen(port, () => {
  console.log(\`Aenzbi Cloud app listening at http://localhost:\${port}\`)
});
EOF

# Setup .env for environment variables
echo "Creating .env file..."
cat << EOF > .env
PORT=3000
MONGODB_URI=mongodb+srv://<username>:<password>@<cluster>.mongodb.net/<dbname>?retryWrites=true&w=majority
JWT_SECRET=yourSecretKey
EOF

# Setup CI/CD with GitHub Actions
echo "Setting up CI/CD workflow..."
mkdir -p .github/workflows
cat << EOF > .github/workflows/main.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [14.x]
    steps:
    - uses: actions/checkout@v2
    - name: Use Node.js \${{ matrix.node-version }}
      uses: actions/setup-node@v2
      with:
        node-version: \${{ matrix.node-version }}
    - name: npm install, build, and test
      run: |
        npm ci
        npm run build --if-present
        npm test
      env:
        CI: true
    - name: Docker Build and Push
      uses: docker/build-push-action@v2
      with:
        username: \${{ secrets.DOCKER_USERNAME }}
        password: \${{ secrets.DOCKER_PASSWORD }}
        repository: aenzbi-cloud
        tags: latest

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
    - name: Deploy to AWS EC2
      uses: appleboy/ssh-action@master
      with:
        host: \${{ secrets.AWS_EC2_HOST }}
        username: ec2-user
        key: \${{ secrets.AWS_EC2_SSH_KEY }}
        script: |
          docker pull aenzbi-cloud:latest
          docker stop aenzbi-cloud-container || true
          docker rm aenzbi-cloud-container || true
          docker run -d -p 80:3000 --name aenzbi-cloud-container aenzbi-cloud:latest
EOF

# Setup Basic Git Branches
echo "Setting up basic git branches..."
git branch -m main
git add .
git commit -m "Initial commit for Aenzbi Cloud Suite"

# Setup for testing
echo "Setting up test environment..."
mkdir test
cat << EOF > test/server.test.js
const request = require('supertest');
const app = require('../server');

describe('GET /', () => {
  it('responds with welcome message', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe('Welcome to Aenzbi Cloud!');
  });
});
EOF
npm install --save-dev supertest jest

# Setup Jest config
echo "Setting up Jest configuration..."
cat << EOF > jest.config.js
module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/test/**/*.test.js'],
};
EOF

# Add scripts to package.json for running tests
jq '.scripts += {"test": "jest"}' package.json > temp.json && mv temp.json package.json

echo "Automation script completed. Please review, customize, and expand based on your project's specific requirements."