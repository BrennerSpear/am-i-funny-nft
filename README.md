# Generic PFP contract

## Overview
Each Generic members can mint one NFT.

Each address that has a Generic PFP NFT will not be able to mint a 2nd NFT. The NFTs are non-transferable by their owners.

<br>
The Generic Multisig has the power to transfer any NFT to another wallet in the event a member's wallet gets compromised or they lose their key.
The contract owner can update the Generic Multisig address in the event the Generic Multisig is compromised or is rotated out of operations.

<br>

## Dev Set up

* Make sure you have the foundry/forge CLI tools installed with a version of >=0.2.0 (see [the docs](https://book.getfoundry.sh/) for help)
* Run `forge install` to install necessary dependencies
* Create a `.env` file like the following...
````
GOERLI_RPC_URL="https://eth-goerli.alchemyapi.io/v2/<YOUR_ALCHEMY_PROJECT_ID>"
MAINNET_RPC_URL="https://eth-mainnet.alchemyapi.io/v2/<YOUR_ALCHEMY_PROJECT_ID>"
PRIVATE_KEY=<DEPLOYER_PRIVATE_KEY>
ETHERSCAN_KEY=<YOUR_ETHERSCAN_KEY>
````
* Run `source .env`
* Check the constructor args in `script/deploy.s.sol`. 

## Deploy to Goerli

* Deploy the contract by running `forge script script/deploy.s.sol:DeployGenericPfp --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_KEY -vvvv`
* Wait a minute or two, and then verify the contract on Etherscan by running `forge script script/deploy.s.sol:DeployGenericPfp --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv`

## Deploy to mainnet

* Deploy the contract by running `forge script script/deploy.s.sol:DeployGenericPfp --rpc-url $MAINNET_RPC_URL --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_KEY -vvvv`
* Wait a minute or two, and then verify the contract on Etherscan by running `forge script script/deploy.s.sol:DeployGenericPfp --rpc-url $MAINNET_RPC_URL --private-key $PRIVATE_KEY --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv`