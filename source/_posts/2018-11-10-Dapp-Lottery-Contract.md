---
title: 'Dapp: Lottery Contract'
mathjax: false
comments: true
author: XS Zhao
categories:
  - blockchain
tags:
  - web3
  - ethereum
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
abbrlink: 41445
date: 2018-11-10 14:08:21
subtitle:
keywords:
description:
---

# Overview

```bash
Lottery Contract

# Variables
Name            Purpose
manager:    Address of person who created the contract
players:    Array of addresses of people who entered

# Function
Name            Purpose
enter:      Enters a player into lottery
pickWinner: Randomly picks a winner and sends them the prize pool

```
<!-- more -->
# Solidity Variable

```bash
Name                Notes                                    Examples
string          Sequence of characthers                     "hi there"
bool            Boolen value                                true, false
int             Integer, positive or negative.              0, -300000
uint            unsigned integer                            0, 3000000
fixed/ufixed    'Fixes' point number                        20.0001, -43.0002
address         Has methods tied to it for sending money    0x01C65bfDeD8c69ef3C28d4EF58F1dA
```

# Reference type

* `fixed array`:  Array the contains a single type of element. length is fixed. int[3] --> [1,2,3]
* `dynamic array`: Array the contains a single type of element. length can change over time. int[] -->[1,2,3]
* `mapping`: Collection of key value pairs.  mapping(string => int)
* `struct`: Collection of key value pairs that can have different types

# msg global variable

* `msg.data`: 'Data' field from the call or transaction that invoked the current function
* `msg.gas` : Amount of gas the current function invocation has available
* `msg.sender`: Address of account that started the current function invocation
* `msg.value`: Amount of ether (in wei) that was sent along with the function invocation

# Lottery logic

![logic](logic.png)

![logic2](logic2.png)

```js :contracts/Lottery.sol
pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;
    
    constructor () public {
        manager = msg.sender;
    }
    
    function enter()  public payable{
        require(msg.value >= .01 ether, "send at least 0.01 ether");
        players.push(msg.sender);
    }

    function random() public view returns (uint) {
        return uint(sha3(block.difficulty, now, players));
    }
    
    // function modifier, reduce code we need to write
    modifier onlyManagerCanCall() {
        // only manage can pick winner
        require(msg.sender == manager, "you don't have authority");
        _; // all code in your function will replace the "_"
    }
    
    function pickWinner() public onlyManagerCanCall{
        uint index = random() % players.length;
        // this.balance has all the ether in current smart contract
        players[index].transfer(address(this).balance); 
        // inital dynamic array whose length is 0;
        players = new address[](0);
    }
    
    function getPlayers() public view returns (address[]) {
        return players;
    }
}
```

You can test this on remix.

# Create a test case

```js :test/Lottery.test.js
const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3')
const web3 = new Web3(ganache.provider());
const {interface, bytecode} = require('../compile')

let lottery;
let accounts;

beforeEach(async () => {
    // Get a list of all accounts
    accounts = await web3.eth.getAccounts();
    
    lottery = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({data: bytecode})
    .send({from: accounts[0], gas: '1000000'})
});

describe('Lottery Contract', () => {
    it('deploys a contract', () => {
        assert.ok(lottery.options.address);
      });

    it('allow one account to enter', async() => {
        await lottery.methods.enter().send({from: accounts[0], value: web3.utils.toWei('0.02', 'ether')});
        
        const players = await lottery.methods.getPlayers().call({
            from: accounts[0]
        });

        assert.equal(accounts[0], players[0]);
        assert.equal(1, players.length);
    });

    it('allow multi account to enter', async() => {
        await lottery.methods.enter().send({from: accounts[0], value: web3.utils.toWei('0.02', 'ether')});
        await lottery.methods.enter().send({from: accounts[1], value: web3.utils.toWei('0.02', 'ether')});
        await lottery.methods.enter().send({from: accounts[2], value: web3.utils.toWei('0.02', 'ether')});
        const players = await lottery.methods.getPlayers().call({
            from: accounts[0]
        });

        assert.equal(accounts[0], players[0]);
        assert.equal(accounts[1], players[1]);
        assert.equal(accounts[2], players[2]);
        assert.equal(3, players.length);
    });

    it('requires a minimum amount of ether to enter', async() => {
        try {
            await lottery.methods.enter().send({
                from: accounts[0],
                value: 0
            });
            assert(false);
        } catch (err) {
            assert(err);
        }
    });

    it('only manage can call pickWinner', async() => {
        try {
            await lottery.methods.pickWinner().send({
                from: accounts[1],
            });
            assert(false);
        } catch (err) {
            assert(err);
        }
    });

    it('sends money to the winner and resets the players', async() => {
        await lottery.methods.enter().send({
            from: accounts[0],
            value: web3.utils.toWei('2', 'ether')
        });

        const initialBalance = await web3.eth.getBalance(accounts[0]);
        await lottery.methods.pickWinner().send({from: accounts[0]});
        const finalBalance = await web3.eth.getBalance(accounts[0]);
        const difference = finalBalance - initialBalance;
        // console.log(difference);
        assert(difference > web3.utils.toWei('1.8', 'ether'));
    });
});
```

```js :./compile.js
const path = require('path');
const fs = require('fs');
const solc = require('solc');

const Path = path.resolve(__dirname, 'contracts', 'Lottery.sol');
const source = fs.readFileSync(Path, 'utf8');

module.exports = solc.compile(source, 1).contracts[':Lottery'];
// console.log(solc.compile(source, 1))
```

then rum `npm run test`

```bash
mac@HansonMac  ~/Code/blockchain  npm run test
> inbox@ test /Users/mac/Code/blockchain
> mocha
Lottery Contract
(node:32122) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 data listeners added. Use emitter.setMaxListeners() to increase limit
    ✓ deploys a contract
    ✓ allow one account to enter (56ms)
    ✓ allow multi account to enter (103ms)
    ✓ requires a minimum amount of ether to enter
    ✓ only manage can call pickWinner
    ✓ sends money to the winner and resets the players (74ms)
```

# Web of ethereum architecture

![](arch.png)

![](metamask.png)

Metamask running in Chrome will inject web3 v2.0 automatically.

Our app will use web3 v1.0, and we want to hijack our provider into Metamask one.

## install react, create new project and install web3

```bash
mac@HansonMac  ~/Code: sudo npm install -g create-react-app
mac@HansonMac  ~/Code: create-react-app lottery-react

Creating a new React app in /Users/mac/Code/lottery-react.

Installing packages. This might take a couple of minutes.
Installing react, react-dom, and react-scripts...

yarn add v1.10.1
[1/4] 🔍  Resolving packages...
[2/4] 🚚  Fetching packages...
[3/4] 🔗  Linking dependencies...
...

mac@HansonMac  ~/Code: yarn add web3@1.0.0-beta.26
mac@HansonMac  ~/Code: npm run start
```


## Hijack Metamask web3 to our version

```js :src/web3.js
import Web3 from 'web3';

// inject our web3 v1.0
const web3 = new Web3(window.web3.currentProvider);

export default web3;
```

```js :src/App.js
// add this to App.js
import web3 from './web3'
```

## Deploy Lottery contract to Rinkeby

```js :./deploy.js
const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const {interface, bytecode} = require('./compile');

const provider = new HDWalletProvider (
    'dinosaur erupt zoo ...',
    'https://rinkeby.infura.io/v3/451daf892abb4101b6845******'
);

const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({data: bytecode})
    .send({gas: '5000000', from: accounts[0]});

    console.log(interface);
    console.log('Contract deployed to', result.options.address);
};

deploy();
```

after run `node deploy.js`

```bash
Attempting to deploy from account 0x01C65bfDeD8c69ef3C28d4EF58F1dA46DeAF13Cd
[{"constant":true,"inputs":[],"name":"manager","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"pickWinner","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"random","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getPlayers","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"enter","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"players","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]
Contract deployed to 0x2a8683527b110f5f37502CD5c7C62f574A75499A
```

## Import ABI

create a new file `lottery.js` in `src` folder. And copy all the ABI and deployed address.

```js :src/lottery.js
import web3 from `./web3`;

const address = '0x2a8683527b110f5f37502CD5c7C62f574A75499A';
const abi = [{
    "constant": true,
    "inputs": [],
    "name": "manager",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "pickWinner",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "random",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getPlayers",
    "outputs": [{
        "name": "",
        "type": "address[]"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "enter",
    "outputs": [],
    "payable": true,
    "stateMutability": "payable",
    "type": "function"
}, {
    "constant": true,
    "inputs": [{
        "name": "",
        "type": "uint256"
    }],
    "name": "players",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "inputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
}];

export default new web3.eth.Contract(abi, address);
```

![abi](abi.png)

## Rendering Contract Data

Modify `src/App.js` code. See source code here:
https://github.com/hansonzhao007/lottery/blob/master/src/App.js


## Deploying React app to GitHub Pages

create a new repository, and connect your project.

install `gh-pages` package

```bash
npm install gh-pages --save-dev
```

Add some properties to the app's package.json file

```js :./package.json
"homepage": "http://gitname.github.io/react-gh-pages"

"scripts": {
  //...
  "predeploy": "npm run build",
  "deploy": "gh-pages -d build"
}
```

Generate a production build of your app, and deploy it to GitHub Pages

```bash
npm run deploy
```

You can see the example on http://xszhao.science/lottery

# Reference

[Deploying a React App* to GitHub Pages](https://github.com/gitname/react-gh-pages)