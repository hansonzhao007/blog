---
title: Write ethereum test code
mathjax: false
comments: true
author: XS Zhao
categories:
  - blockchain
tags:
  - web3
  - ethereum
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
abbrlink: 34389
date: 2018-11-10 09:37:55
subtitle:
keywords:
description:
---

# Overview

The fold tree is like following:

```bash
--| contracts
----| Inbox.sol
--| test
----| Inbox_test.js
--| compile.js
--| package.json
```
<!-- more -->
# Code 

## Smart Contract

```js :Inbox.sol
pragma solidity ^0.4.17;

contract Inbox {
    // a globle store
    string public message;
    
    function Inbox(string initialMessage) public {
        message = initialMessage;
    }
    
    function setMessage(string newMessage) public {
        message = newMessage;
    }
}
```

## Compile Script

```js :compile.js
const path = require('path');
const fs = require('fs');
const solc = require('solc');

const inboxPath = path.resolve(__dirname, 'contracts', 'Inbox.sol');
const source = fs.readFileSync(inboxPath, 'utf8');

console.log(solc.compile(source, 1))

// export the smart contract bytecode and interface, which are used to create or deploy a contract, interact with the contract.
// module.exports = solc.compile(source, 1).contracts[':Inbox'];
```

run `node compile`:

```bash
{ contracts:
  # we will see multiple contract pairs if we use compile.js to compile multiple smart contracts
   { ':Inbox': # contract name
      { assembly: [Object],
        # `bytecode is the actual content that is deployed on ethereum network`
        bytecode: '608060405234801561001057600080fd5b5060405161038c38038061038c83398101604052805101805161003a906000906020840190610041565b50506100dc565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061008257805160ff19168380011785556100af565b828001600101855582156100af579182015b828111156100af578251825591602001919060010190610094565b506100bb9291506100bf565b5090565b6100d991905b808211156100bb57600081556001016100c5565b90565b6102a1806100eb6000396000f30060806040526004361061004b5763ffffffff7c0100000000000000000000000000000000000000000000000000000000600035041663368b87728114610050578063e21f37ce146100ab575b600080fd5b34801561005c57600080fd5b506040805160206004803580820135601f81018490048402850184019095528484526100a99436949293602493928401919081908401838280828437509497506101359650505050505050565b005b3480156100b757600080fd5b506100c061014c565b6040805160208082528351818301528351919283929083019185019080838360005b838110156100fa5781810151838201526020016100e2565b50505050905090810190601f1680156101275780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b80516101489060009060208401906101da565b5050565b6000805460408051602060026001851615610100026000190190941693909304601f810184900484028201840190925281815292918301828280156101d25780601f106101a7576101008083540402835291602001916101d2565b820191906000526020600020905b8154815290600101906020018083116101b557829003601f168201915b505050505081565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061021b57805160ff1916838001178555610248565b82800160010185558215610248579182015b8281111561024857825182559160200191906001019061022d565b50610254929150610258565b5090565b61027291905b80821115610254576000815560010161025e565b905600a165627a7a72305820387e3a84c249a8fe3de554c17239e7aefa478da030f9a901807f3b1989c4d9020029',
        functionHashes: [Object],
        gasEstimates: [Object],
        # `Our contract ABI`
        # `List out all the function we can use`
        interface: '[{"constant":false,"inputs":[{"name":"newMessage","type":"string"}],"name":"setMessage","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"message","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"initialMessage","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]',
        metadata: '{"compiler":{"version":"0.4.25+commit.59dbf8f1"},"language":"Solidity","output":{"abi":[{"constant":false,"inputs":[{"name":"newMessage","type":"string"}],"name":"setMessage","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"message","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"initialMessage","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}],"devdoc":{"methods":{}},"userdoc":{"methods":{}}},"settings":{"compilationTarget":{"":"Inbox"},"evmVersion":"byzantium","libraries":{},"optimizer":{"enabled":true,"runs":200},"remappings":[]},"sources":{"":{"keccak256":"0xcbb1d3ea37d011841c666c5ac8aeb21eacca3d151de9e40dde61095138cc17c0","urls":["bzzr://2d2ff492c4461ba96d5e54274865acbc8bdb43f00337d4222681d001a6ea05f3"]}},"version":1}',
        opcodes: 'PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE DUP1 ISZERO PUSH2 0x10 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH1 0x40MLOAD PUSH2 0x38C CODESIZE SUB DUP1 PUSH2 0x38C DUP4 CODECOPY DUP2 ADD PUSH1 0x40 MSTORE DUP1 MLOAD ADD DUP1 MLOAD PUSH2 0x3A SWAP1PUSH1 0x0 SWAP1 PUSH1 0x20 DUP5 ADD SWAP1 PUSH2 0x41 JUMP JUMPDEST POP POP PUSH2 0xDC JUMP JUMPDEST DUP3 DUP1 SLOAD PUSH1 0x1 DUP2 PUSH1 0x1 AND ISZERO PUSH2 0x100 MUL SUB AND PUSH1 0x2 SWAP1 DIV SWAP1 PUSH1 0x0 MSTORE PUSH1 0x20 PUSH1 0x0 KECCAK256 SWAP1 PUSH1 0x1F ADD PUSH1 0x20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH1 0x1F LT PUSH2 0x82 JUMPI DUP1 MLOAD PUSH1 0xFF NOT AND DUP4 DUP1 ADD OR DUP6 SSTORE PUSH2 0xAF JUMP JUMPDEST DUP3 DUP1 ADD PUSH1 0x1 ADD DUP6 SSTORE DUP3 ISZERO PUSH2 0xAF JUMPI SWAP2 DUP3 ADD JUMPDEST DUP3 DUP2 GT ISZERO PUSH2 0xAF JUMPI DUP3 MLOAD DUP3 SSTORE SWAP2 PUSH1 0x20 ADD SWAP2 SWAP1 PUSH1 0x1 ADD SWAP1 PUSH2 0x94 JUMP JUMPDEST POP PUSH2 0xBB SWAP3 SWAP2 POP PUSH2 0xBF JUMP JUMPDEST POP SWAP1 JUMP JUMPDEST PUSH2 0xD9 SWAP2 SWAP1 JUMPDEST DUP1 DUP3 GT ISZERO PUSH2 0xBB JUMPI PUSH1 0x0 DUP2 SSTORE PUSH1 0x1 ADD PUSH2 0xC5 JUMP JUMPDEST SWAP1 JUMP JUMPDEST PUSH2 0x2A1 DUP1 PUSH2 0xEB PUSH1 0x0 CODECOPY PUSH1 0x0 RETURN STOP PUSH1 0x80 PUSH1 0x40 MSTORE PUSH1 0x4 CALLDATASIZE LT PUSH2 0x4B JUMPI PUSH4 0xFFFFFFFF PUSH29 0x100000000000000000000000000000000000000000000000000000000 PUSH1 0x0 CALLDATALOAD DIV AND PUSH4 0x368B8772 DUP2 EQ PUSH2 0x50 JUMPI DUP1 PUSH4 0xE21F37CE EQ PUSH2 0xAB JUMPI JUMPDEST PUSH1 0x0 DUP1 REVERT JUMPDEST CALLVALUE DUP1 ISZERO PUSH2 0x5C JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH1 0x40 DUP1 MLOAD PUSH1 0x20 PUSH1 0x4 DUP1 CALLDATALOAD DUP1 DUP3 ADD CALLDATALOAD PUSH1 0x1F DUP2 ADD DUP5 SWAP1 DIV DUP5 MUL DUP6 ADD DUP5 ADD SWAP1 SWAP6 MSTORE DUP5 DUP5 MSTORE PUSH2 0xA9 SWAP5 CALLDATASIZE SWAP5 SWAP3 SWAP4 PUSH1 0x24 SWAP4 SWAP3 DUP5 ADD SWAP2 SWAP1 DUP2 SWAP1 DUP5 ADD DUP4 DUP3 DUP1 DUP3 DUP5 CALLDATACOPY POP SWAP5 SWAP8 POP PUSH2 0x135 SWAP7POP POP POP POP POP POP POP JUMP JUMPDEST STOP JUMPDEST CALLVALUE DUP1 ISZERO PUSH2 0xB7 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH2 0xC0 PUSH2 0x14C JUMP JUMPDEST PUSH1 0x40 DUP1 MLOAD PUSH1 0x20 DUP1 DUP3 MSTORE DUP4 MLOAD DUP2 DUP4 ADD MSTORE DUP4 MLOAD SWAP2 SWAP3 DUP4 SWAP3 SWAP1 DUP4 ADD SWAP2 DUP6 ADD SWAP1 DUP1 DUP4 DUP4 PUSH1 0x0 JUMPDEST DUP4 DUP2 LT ISZERO PUSH2 0xFA JUMPI DUP2 DUP2 ADD MLOAD DUP4 DUP3 ADD MSTORE PUSH1 0x20 ADD PUSH2 0xE2 JUMP JUMPDEST POP POP POP POP SWAP1 POP SWAP1 DUP2 ADD SWAP1 PUSH1 0x1F AND DUP1 ISZERO PUSH2 0x127 JUMPI DUP1 DUP3 SUB DUP1 MLOAD PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB NOT AND DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP JUMPDEST POP SWAP3 POP POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST DUP1 MLOAD PUSH2 0x148 SWAP1 PUSH1 0x0 SWAP1 PUSH1 0x20 DUP5 ADD SWAP1 PUSH2 0x1DA JUMP JUMPDEST POP POP JUMP JUMPDEST PUSH1 0x0 DUP1 SLOAD PUSH1 0x40 DUP1MLOAD PUSH1 0x20 PUSH1 0x2 PUSH1 0x1 DUP6 AND ISZERO PUSH2 0x100 MUL PUSH1 0x0 NOT ADD SWAP1 SWAP5 AND SWAP4 SWAP1 SWAP4 DIV PUSH1 0x1F DUP2 ADD DUP5 SWAP1 DIV DUP5 MUL DUP3 ADD DUP5 ADD SWAP1 SWAP3 MSTORE DUP2 DUP2 MSTORE SWAP3 SWAP2 DUP4 ADD DUP3 DUP3 DUP1 ISZERO PUSH2 0x1D2 JUMPI DUP1 PUSH1 0x1F LT PUSH2 0x1A7 JUMPI PUSH2 0x100 DUP1 DUP4 SLOAD DIV MUL DUP4 MSTORE SWAP2 PUSH1 0x20 ADD SWAP2PUSH2 0x1D2 JUMP JUMPDEST DUP3 ADD SWAP2 SWAP1 PUSH1 0x0 MSTORE PUSH1 0x20 PUSH1 0x0 KECCAK256 SWAP1 JUMPDEST DUP2 SLOAD DUP2 MSTORE SWAP1 PUSH1 0x1 ADD SWAP1 PUSH1 0x20 ADD DUP1 DUP4 GT PUSH2 0x1B5 JUMPI DUP3 SWAP1 SUB PUSH1 0x1F AND DUP3 ADD SWAP2 JUMPDEST POP POP POP POP POP DUP2 JUMP JUMPDEST DUP3 DUP1 SLOAD PUSH1 0x1 DUP2 PUSH1 0x1 AND ISZERO PUSH2 0x100 MUL SUB AND PUSH1 0x2 SWAP1 DIV SWAP1 PUSH1 0x0 MSTORE PUSH1 0x20 PUSH1 0x0 KECCAK256 SWAP1 PUSH1 0x1F ADD PUSH1 0x20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH1 0x1F LT PUSH2 0x21B JUMPI DUP1 MLOAD PUSH1 0xFF NOT AND DUP4 DUP1 ADD OR DUP6 SSTORE PUSH2 0x248 JUMP JUMPDEST DUP3 DUP1 ADD PUSH1 0x1 ADD DUP6SSTORE DUP3 ISZERO PUSH2 0x248 JUMPI SWAP2 DUP3 ADD JUMPDEST DUP3 DUP2 GT ISZERO PUSH2 0x248 JUMPI DUP3 MLOAD DUP3 SSTORE SWAP2 PUSH1 0x20 ADD SWAP2 SWAP1 PUSH1 0x1 ADD SWAP1 PUSH2 0x22D JUMP JUMPDEST POP PUSH2 0x254 SWAP3 SWAP2 POP PUSH2 0x258 JUMP JUMPDEST POP SWAP1 JUMP JUMPDEST PUSH2 0x272 SWAP2 SWAP1 JUMPDEST DUP1 DUP3 GT ISZERO PUSH2 0x254 JUMPI PUSH1 0x0 DUP2 SSTORE PUSH1 0x1 ADD PUSH20x25E JUMP JUMPDEST SWAP1 JUMP STOP LOG1 PUSH6 0x627A7A723058 KECCAK256 CODESIZE PUSH31 0x3A84C249A8FE3DE554C17239E7AEFA478DA030F9A901807F3B1989C4D90200 0x29 ',
        runtimeBytecode: '60806040526004361061004b5763ffffffff7c0100000000000000000000000000000000000000000000000000000000600035041663368b87728114610050578063e21f37ce146100ab575b600080fd5b34801561005c57600080fd5b506040805160206004803580820135601f81018490048402850184019095528484526100a99436949293602493928401919081908401838280828437509497506101359650505050505050565b005b3480156100b757600080fd5b506100c061014c565b6040805160208082528351818301528351919283929083019185019080838360005b838110156100fa5781810151838201526020016100e2565b50505050905090810190601f1680156101275780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b80516101489060009060208401906101da565b5050565b6000805460408051602060026001851615610100026000190190941693909304601f810184900484028201840190925281815292918301828280156101d25780601f106101a7576101008083540402835291602001916101d2565b820191906000526020600020905b8154815290600101906020018083116101b557829003601f168201915b505050505081565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061021b57805160ff1916838001178555610248565b82800160010185558215610248579182015b8281111561024857825182559160200191906001019061022d565b50610254929150610258565b5090565b61027291905b80821115610254576000815560010161025e565b905600a165627a7a72305820387e3a84c249a8fe3de554c17239e7aefa478da030f9a901807f3b1989c4d9020029',
        srcmap: '26:242:0:-;;;87:86;8:9:-1;5:2;;;30:1;27;20:12;5:2;87:86:0;;;;;;;;;;;;;;;;;142:24;;;;:7;;:24;;;;;:::i;:::-;;87:86;26:242;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-1:-1:-1;26:242:0;;;-1:-1:-1;26:242:0;:::i;:::-;;;:::o;:::-;;;;;;;;;;;;;;;;;;;;:::o;:::-;;;;;;;',
        srcmapRuntime: '26:242:0:-;;;;;;;;;;;;;;;;;;;;;;;;;;;;183:83;;8:9:-1;5:2;;;30:1;27;20:12;5:2;-1:-1;183:83:0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-1:-1:-1;183:83:0;;-1:-1:-1;183:83:0;;-1:-1:-1;;;;;;;183:83:0;;;55:21;;8:9:-1;5:2;;;30:1;27;20:12;5:2;55:21:0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;8:100:-1;33:3;30:1;27:10;8:100;;;90:11;;;84:18;71:11;;;64:39;52:2;45:10;8:100;;;12:14;55:21:0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;183:83;239:20;;;;:7;;:20;;;;;:::i;:::-;;183:83;:::o;55:21::-;;;;;;;;;;;;;;;-1:-1:-1;;55:21:0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::o;26:242::-;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-1:-1:-1;26:242:0;;;-1:-1:-1;26:242:0;:::i;:::-;;;:::o;:::-;;;;;;;;;;;;;;;;;;;;:::o' } },
  errors:
   [ ':7:5: Warning: Defining constructors as functions with the same name as the contract is deprecated. Use "constructor(...) { ... }" instead.\n    function Inbox(string initialMessage) public {\n    ^ (Relevant source part starts here and spans across multiple lines).\n' ],
  sourceList: [ '' ],
  sources: { '': { AST: [Object] } } }
```
## Test case

```js :Inbox_test.js
const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3')
const web3 = new Web3(ganache.provider());
// in order to use the compiled module, change the last line in compile.js to 
// module.exports = solc.compile(source, 1).contracts[':Inbox'];
const {interface, bytecode} = require('../compile')

let accounts;

beforeEach(async () => {
    // Get a list of all accounts
    accounts = await web3.eth.getAccounts();
    
    // Use one of those accounts to deploy
    // the constract
    inbox = await new web3.eth.Contract(JSON.parse(interface)) 
    // use web3 module eth, and the function Contract of eth module. 
    // This function can be used to interact with the contract exist 
    // in blockchain or deploy a new contract instance.
    .deploy({data: bytecode, arguments: ['Hi there!']})
    // create a smart contract, create a new instance and call Inbox() function
    // passing argument 'Hi there!'. deploy the instance to ethereum
    .send({from: accounts[0], gas: '1000000'});
    // Instructs web3 to send out a transaction that creates this contract
    // specify who is going to deploying the contract
});


describe('Inbox', () => {
    it('deploys a contract', () => {
        assert.ok(inbox.options.address);
      });

    it('has a default message', async () => {
        const message = await inbox.methods.message().call();
        assert.equal(message, 'Hi there!');
    });

    it('can change message', async () => {
        // because you want to modify, so you need to identify who is going to change and the gas you want to pay
        await inbox.methods.setMessage('bye').send({from: accounts[0], gas: '1000000'});
        const message = await inbox.methods.message().call();
        assert.equal(message, 'bye');
    });
});
```

then run `npm run text`:

```bash
> inbox@ test /Users/mac/Code/blockchain
> mocha

  Inbox
(node:24604) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 data listeners added. Use emitter.setMaxListeners() to increase limit
Contract {
  currentProvider: [Getter/Setter],
  _requestManager:
   RequestManager {
     provider:
      l {
        domain: null,
        _events: [Object],
        _eventsCount: 1,
        _maxListeners: undefined,
        options: [Object],
        engine: [Object],
        manager: [Object],
        sendAsync: [Function: bound ],
        send: [Function: bound ],
        close: [Function: bound ],
        _queueRequest: [Function: bound ],
        _processRequestQueue: [Function: bound ],
        _requestQueue: [],
        _requestInProgress: false },
     providers:
      { WebsocketProvider: [Function: WebsocketProvider],
        HttpProvider: [Function: HttpProvider],
        IpcProvider: [Function: IpcProvider] },
     subscriptions: {} },
  givenProvider: null,
  # the communication layer with actual block chain
  providers:
   { WebsocketProvider: [Function: WebsocketProvider],
     HttpProvider: [Function: HttpProvider],
     IpcProvider: [Function: IpcProvider] },
  _provider:
   l {
     domain: null,
     _events: { data: [Array] },
     _eventsCount: 1,
     _maxListeners: undefined,
     options:
      { vmErrorsOnRPCResponse: true,
        verbose: false,
        asyncRequestProcessing: false,
        logger: [Object],
        seed: 'lE5BIQtDPC',
        mnemonic: 'fetch frequent marble basket mad split print order census canyon spot ugly',
        network_id: 1541867444670,
        total_accounts: 10,
        gasPrice: '0x77359400',
        default_balance_ether: 100,
        unlocked_accounts: [],
        hdPath: 'm/44\'/60\'/0\'/0/',
        gasLimit: '0x6691b7',
        defaultTransactionGasLimit: '0x15f90',
        time: null,
        debug: false,
        allowUnlimitedContractSize: false },
     engine:
      s {
        domain: null,
        _events: [Object],
        _eventsCount: 1,
        _maxListeners: 100,
        _blockTracker: [Object],
        _ready: [Object],
        currentBlock: [Object],
        _providers: [Array],
        manager: [Object] },
     manager:
      s {
        state: [Object],
        options: [Object],
        initialized: true,
        initialization_error: null,
        post_initialization_callbacks: [],
        engine: [Object],
        currentBlock: [Object] },
     sendAsync: [Function: bound ],
     send: [Function: bound ],
     close: [Function: bound ],
     _queueRequest: [Function: bound ],
     _processRequestQueue: [Function: bound ],
     _requestQueue: [],
     _requestInProgress: false },
  setProvider: [Function],
  BatchRequest: [Function: bound Batch],
  extend:
   { [Function: ex]
     formatters:
      { inputDefaultBlockNumberFormatter: [Function: inputDefaultBlockNumberFormatter],
        inputBlockNumberFormatter: [Function: inputBlockNumberFormatter],
        inputCallFormatter: [Function: inputCallFormatter],
        inputTransactionFormatter: [Function: inputTransactionFormatter],
        inputAddressFormatter: [Function: inputAddressFormatter],
        inputPostFormatter: [Function: inputPostFormatter],
        inputLogFormatter: [Function: inputLogFormatter],
        inputSignFormatter: [Function: inputSignFormatter],
        outputBigNumberFormatter: [Function: outputBigNumberFormatter],
        outputTransactionFormatter: [Function: outputTransactionFormatter],
        outputTransactionReceiptFormatter: [Function: outputTransactionReceiptFormatter],
        outputBlockFormatter: [Function: outputBlockFormatter],
        outputLogFormatter: [Function: outputLogFormatter],
        outputPostFormatter: [Function: outputPostFormatter],
        outputSyncingFormatter: [Function: outputSyncingFormatter] },
     utils:
      { _fireError: [Function: _fireError],
        _jsonInterfaceMethodToString: [Function: _jsonInterfaceMethodToString],
        _flattenTypes: [Function: _flattenTypes],
        randomHex: [Function: randomHex],
        _: [Object],
        BN: [Object],
        isBN: [Function: isBN],
        isBigNumber: [Function: isBigNumber],
        isHex: [Function: isHex],
        isHexStrict: [Function: isHexStrict],
        sha3: [Object],
        keccak256: [Object],
        soliditySha3: [Function: soliditySha3],
        isAddress: [Function: isAddress],
        checkAddressChecksum: [Function: checkAddressChecksum],
        toChecksumAddress: [Function: toChecksumAddress],
        toHex: [Function: toHex],
        toBN: [Function: toBN],
        bytesToHex: [Function: bytesToHex],
        hexToBytes: [Function: hexToBytes],
        hexToNumberString: [Function: hexToNumberString],
        hexToNumber: [Function: hexToNumber],
        toDecimal: [Function: hexToNumber],
        numberToHex: [Function: numberToHex],
        fromDecimal: [Function: numberToHex],
        hexToUtf8: [Function: hexToUtf8],
        hexToString: [Function: hexToUtf8],
        toUtf8: [Function: hexToUtf8],
        utf8ToHex: [Function: utf8ToHex],
        stringToHex: [Function: utf8ToHex],
        fromUtf8: [Function: utf8ToHex],
        hexToAscii: [Function: hexToAscii],
        toAscii: [Function: hexToAscii],
        asciiToHex: [Function: asciiToHex],
        fromAscii: [Function: asciiToHex],
        unitMap: [Object],
        toWei: [Function: toWei],
        fromWei: [Function: fromWei],
        padLeft: [Function: leftPad],
        leftPad: [Function: leftPad],
        padRight: [Function: rightPad],
        rightPad: [Function: rightPad],
        toTwosComplement: [Function: toTwosComplement] },
     Method: [Function: Method] },
  clearSubscriptions: [Function],
  options:
   { address: [Getter/Setter],
     jsonInterface: [Getter/Setter],
     data: undefined,
     from: undefined,
     gasPrice: undefined,
     gas: undefined },
  defaultAccount: [Getter/Setter],
  defaultBlock: [Getter/Setter],
  # methods you define in the smart contract
  methods:
   { setMessage: [Function: bound _createTxObject],
     '0x368b8772': [Function: bound _createTxObject],
     'setMessage(string)': [Function: bound _createTxObject],
     message: [Function: bound _createTxObject],
     '0xe21f37ce': [Function: bound _createTxObject],
     'message()': [Function: bound _createTxObject] },
  events: { allEvents: [Function: bound ] },
  _address: '0x2E4631F207D3564B7937Bf355d947c187D9a1Fad',
  _jsonInterface:
   [ { constant: false,
       inputs: [Array],
       name: 'setMessage',
       outputs: [],
       payable: false,
       stateMutability: 'nonpayable',
       type: 'function',
       signature: '0x368b8772' },
     { constant: true,
       inputs: [],
       name: 'message',
       outputs: [Array],
       payable: false,
       stateMutability: 'view',
       type: 'function',
       signature: '0xe21f37ce' },
     { inputs: [Array],
       payable: false,
       stateMutability: 'nonpayable',
       type: 'constructor',
       constant: undefined,
       signature: 'constructor' } ] }
    ✓ deploy a contract


  1 passing (225ms)
```

# Deploy to ethereum

![deploy](deploy.png)

* `Infura API`: provide the interface of real ethereum block chain.
* `Provider`: a interface layer to communicate with real block chain using your account.

## Get infura api

Go to infura.io to creata a new account and project. 

![](infura.png)

## Deploy

```js :deploy.js
const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const {interface, bytecode} = require('./compile');

const provider = new HDWalletProvider (
    'dinosaur erupt zoo ...', // your account
    'https://rinkeby.infura.io/v3/451daf892abb41***' // block chain api, you can obtain this from rinkeby.infura.io website inside your project.
);

const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({data: bytecode, arguments: ['Hi there!']})
    .send({gas: '5000000', from: accounts[0]});

    console.log('Contract deployed to', result.options.address);
};

deploy();
```

```bash
mac@HansonMac  ~/Code/blockchain  node deploy.js
Attempting to deploy from account 0x01C65bfDeD8c69ef3C28d4EF58F1dA46DeAF13Cd
Contract deployed to 0xF0f127B8eC22da8e811262B287BA6b8244B22891
```

copy `0xF0f127B8eC22da8e811262B287BA6b8244B22891` to `rinkey.etherscan.io` to see the results.

![rinkeby](rinkeby.png)

# Interact with real ethereum

Go to remix website

copy `0xF0f127B8eC22da8e811262B287BA6b8244B22891` to `At Address`, and click.

You will see the contract deployed in real ethereum network.

![](remix.png)

You can then try to setMessage, for example: 'Test real ethereum'.

After your submition, the transaction will be in `pending` state.

![pending](pending.png)

While in the pending state, the value of message will not change. After the transaction is confirmed, `message` function will return the new value: 'Test real ethereum'.


# Reference
- [Error: The contract code couldn't be stored, please check your gas limit](https://stackoverflow.com/questions/50201353/unhandledpromiserejectionwarning-error-the-contract-code-couldnt-be-stored-p)
- [rinkey.etherscan.io](https://rinkeby.etherscan.io/)