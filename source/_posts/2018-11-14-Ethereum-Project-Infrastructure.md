---
title: Ethereum Project Infrastructure
mathjax: false
comments: true
author: XS Zhao
categories:
  - blockchain
tags:
  - web3
  - ethereum
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
abbrlink: 30972
date: 2018-11-14 16:42:55
subtitle:
keywords:
description:
---

# Prepare

```bash
mkdir kickstart
cd kickstart
npm init # create package.json file
npm install --save ganache-cli mocha solc fs-extra web3@1.0.0-beta.26
```

<!-- more -->

# Overview

Create a blockchain kickstart website.

## Contract

![contract](contract.png)

## Structure

![structure](structure.png)
![overview](overview.png)
![interact](interact.png)

1. create a factory contract. It has a function to deploy a new instance of `Campaign`
2. User clicks `Create Campaign`
3. We instruct web3/metamask to show user a transaction that invokes `Campaign Factory`
4. User pays deployment costs. Factory deploy a new copy of `Campaign`
5. We tell `Campaign Factory` to give us a list of all deployed campaigns.

# 