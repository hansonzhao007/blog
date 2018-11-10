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

```js
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

```js :Lottery.test.js
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

```js :compile.js
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

