---
title: first docker app
mathjax: false
comments: true
author: XS Zhao
categories:
  - docker
tags:
  - nodejs
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
abbrlink: 62377
date: 2018-09-05 15:43:57
subtitle:
keywords:
description:
---

# Preparation

Create a new directory where all the files would live.

## Create Node.js app

```json :package.json
{
  "name": "docker_web_app",
  "version": "1.0.0",
  "description": "Node.js on Docker",
  "author": "First Last <first.last@example.com>",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.16.1"
  }
}
```
<!-- more -->

With your new `package.json` file, run `npm install`. If you are using npm version 5 or later, this will generate a `package-lock.json` file which will be copied to your Docker image.

Then, create a `server.js` file that defines a web app using the Express.js framework:

```js :server.js
'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello world\n');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
```

## Creating a Dockerfile

```bash :Dockerfile
# use the latest LTS (long term support) version 8 of node available from the Docker Hub:
FROM node:8

# Create app directory
WORKDIR /usr/src/app

# This image comes with Node.js and NPM already installed so the next thing we need to do 
# is to install your app dependencies using the npm binary.
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# To bundle your app's source code inside the Docker image, use the COPY instruction:
# Bundle app source
COPY . .

# Your app binds to port 8080 so you'll use the EXPOSE instruction to have it mapped 
# by the docker daemon:
EXPOSE 8080

# Last but not least, define the command to run your app using CMD which defines your runtime. # Here we will use the basic npm start which will run node server.js to start your server:
CMD [ "npm", "start" ]
```

Create a `.dockerignore` file in the same directory as your `Dockerfile` with following content:

```bash
node_modules
npm-debug.log
```

This will prevent your local modules and debug logs from being copied onto your Docker image and possibly overwriting modules installed within your image.

# Building your image

Go to the directory that has your Dockerfile and run the following command to build the Docker image. The `-t` flag lets you tag your image so it's easier to find later using the `docker images` command:

```bash
docker build -t <your username>/node-web-app .
```

Your image will now be listed by Docker:

```bash
mac@HansonMac  ~/Code/docker/test1  docker images
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
hansonzhao007/node-web-app   latest              d9a6394dc754        21 minutes ago      675MB
node                         8                   8198006b2b57        11 hours ago        673MB
hello-world                  latest              2cb0d9787c4d        8 weeks ago         1.85kB
```

# How docker utilize layer cache

The first time we build docker image:
```bash
mac@HansonMac  ~/Code/docker/test1  docker build -t hansonzhao007/node-web-app .
Sending build context to Docker daemon  18.94kB
Step 1/7 : FROM node:8
8: Pulling from library/node
f189db1b88b3: Pull complete
3d06cf2f1b5e: Pull complete
687ebdda822c: Pull complete
99119ca3f34e: Pull complete
e771d6006054: Pull complete
b0cc28d0be2c: Pull complete
9bbe77ca0944: Pull complete
75f7d70e2d07: Pull complete
Digest: sha256:47a2131abc86d41faa910465b35987bc06b014c335309b551c876e517b5a4402
Status: Downloaded newer image for node:8
 ---> 8198006b2b57
Step 2/7 : WORKDIR /usr/src/app
 ---> Running in 4137ea639ed8
Removing intermediate container 4137ea639ed8
 ---> 549d3e18b855
Step 3/7 : COPY package*.json ./
 ---> f290910d8f59
Step 4/7 : RUN npm install
 ---> Running in eb632572e423
npm WARN docker_web_app@1.0.0 No repository field.
npm WARN docker_web_app@1.0.0 No license field.

added 50 packages in 1.753s
Removing intermediate container eb632572e423
 ---> 17748bcde097
Step 5/7 : COPY . .
 ---> fdb83d4c8598
Step 6/7 : EXPOSE 8080
 ---> Running in 69d1ada16879
Removing intermediate container 69d1ada16879
 ---> 87924dc046d8
Step 7/7 : CMD [ "npm", "start" ]
 ---> Running in 90c7d806a20b
Removing intermediate container 90c7d806a20b
 ---> d9a6394dc754
Successfully built d9a6394dc754
Successfully tagged hansonzhao007/node-web-app:latest
```

We see that every layer need to be rebuilt.

Then we try to rebuild it again:
```bash
mac@HansonMac  ~/Code/docker/test1  docker build -t hansonzhao007/node-web-app .
Sending build context to Docker daemon  18.94kB
Step 1/7 : FROM node:8
 ---> 8198006b2b57
Step 2/7 : WORKDIR /usr/src/app
 ---> Using cache
 ---> 549d3e18b855
Step 3/7 : COPY package*.json ./
 ---> Using cache
 ---> d124378627e9
Step 4/7 : RUN npm install
 ---> Using cache
 ---> 2ce3c2c8249a
Step 5/7 : COPY . .
 ---> Using cache
 ---> ffca5856eb53
Step 6/7 : EXPOSE 8080
 ---> Using cache
 ---> bdcc9c0cc503
Step 7/7 : CMD [ "npm", "start" ]
 ---> Using cache
 ---> d93edfeb4525
Successfully built d93edfeb4525
Successfully tagged hansonzhao007/node-web-app:latest
```

We can see that for every CMD, there is a `Using cache`.

## What are the layers

Docker containers are building blocks for applications. Each container is an image with a readable/writeable layer on top of a bunch of read-only layers.

These layers (also called intermediate images) are generated when the commands in the Dockerfile are executed during the Docker image build.

When Docker builds the container from a Dockerfile, each step corresponds to a command run in the Dockerfile. And each layer is made up of the file generated from running that command.

For example, the layer ID for step 2 is `549d3e18b855`.

```bash
mac@HansonMac  ~/Code/docker/test1  docker build -t hansonzhao007/node-web-app .
Sending build context to Docker daemon  18.94kB
Step 1/7 : FROM node:8
 ---> 8198006b2b57
Step 2/7 : WORKDIR /usr/src/app
 ---> Using cache
 ---> 549d3e18b855
Step 3/7 : COPY package*.json ./
...
```

Once the image is built, you can view all the layers that make up the image with the docker history command. The “Image” column (i.e `intermediate image` or `layer`) shows the randomly generated UUID that correlates to that layer.

```bash
 mac@HansonMac  ~/Code/docker/test1  docker history hansonzhao007/node-web-app
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
d93edfeb4525        7 minutes ago       /bin/sh -c #(nop)  CMD ["npm" "start"]          0B
bdcc9c0cc503        7 minutes ago       /bin/sh -c #(nop)  EXPOSE 8080                  0B
ffca5856eb53        7 minutes ago       /bin/sh -c #(nop) COPY dir:61b10d9a51757f95e…   14kB
2ce3c2c8249a        7 minutes ago       /bin/sh -c npm install                          2.91MB
d124378627e9        7 minutes ago       /bin/sh -c #(nop) COPY multi:6b51dc5ec4af055…   13.3kB
549d3e18b855        31 minutes ago      /bin/sh -c #(nop) WORKDIR /usr/src/app          0B
8198006b2b57        11 hours ago        /bin/sh -c #(nop)  CMD ["node"]                 0B
```

# Reference
[Digging into Docker layers](https://medium.com/@jessgreb01/digging-into-docker-layers-c22f948ed612)
[Dockerizing a Node.js web app](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)
[Building Efficient Dockerfiles - Node.js](http://bitjudo.com/blog/2014/03/13/building-efficient-dockerfiles-node-dot-js/)