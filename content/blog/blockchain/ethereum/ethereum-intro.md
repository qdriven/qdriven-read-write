# Ethereum Blockchain Cheetsheat

## What's Blockchain

- public database updated and shared across many computers
- Block: refers the fact that data and state are stored in sequential batches or "blocks"
- Chain: refers to the fact the each block cryptographically references its parent. A block can't be changed
  without chaning all subsequent block, which require consensus of the entire network. why?
- Node: very computer in the network
- Consensus mechanism: proof-of-worl/proof-of-stake

[blockchain-demo](http://anders.com/blockchain/)

- how proof-of-work works?

## ETH/EVM

- ETH, native cryptocurrency of Ethereum, users pay ether to other users to have their code execution requests fulfilled.
- EVM, virtual machine for executing arbitrary code or byte codes.
  
## Nodes

- real-life machines storing EVM state

## Accounts

- where ether stored
- Account is like a address
- Two types:
  - external-owned
  - contract 
  - both can receive and interactive with deployed contracts
- Account Examined
  - nonce
  - balance
  - codeHash: 
  - storageRoot – Sometimes known as a storage hash. A 256-bit hash of the root node of a Merkle Patricia trie that encodes the storage contents   of the account (a mapping between 256-bit integer values), encoded into the trie as a mapping from the Keccak 256-bit hash of the 256-bit integer keys to the RLP-encoded 256-bit integer values. This trie encodes the hash of the storage contents of this account, and is empty by default.

![img](https://ethereum.org/static/19443ab40f108c985fb95b07bac29bcb/302a4/accounts.png)

## Transactions

a fulfilled transaction request and the associated change in the EVM state

## Blocks

## Smart Contract

## Dapp

- dapp has its backend in decentralized peer-to-peer network
- 