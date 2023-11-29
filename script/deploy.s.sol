// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "../src/AmIFunny.sol";

contract DeployAmIFunny is Script {
    function run() external {
        vm.startBroadcast();

        string memory name = "Am I Funny?";
        string memory symbol = "AIF";
        string memory slug = "amIFunny";

        bool isMainnet = block.chainid == 1;
        bool isBase = block.chainid == 8453;

        bool isProd = isMainnet || isBase;

        // use a different address if the chain is mainnet
        address validSigner = isProd ? 0xF04284F4470230b4f19C1dCa4FC9cd0f93170Ba6 : 0x9DfaEf433F3257600b27734d5cD8155a5c389604;

        uint256 mintsPerAddress = isProd ? 1 : 1000;
        bool isMintActive = isProd ? false : true;
        address metagameAddress = 0x9D8395A406FA264DeA71671c772269e844264E8C; // TODO Update this address
        string memory metadataFolderUri = isProd ? "https://blocklander.vercel.app/api/nft" : "https://dev-blocklander.vercel.app/api/nft";
        string memory contractMetadataUrl = isProd ? "https://blocklander.vercel.app/api/contract-metadata" : "https://dev-blocklander.vercel.app/api/contract-metadata";

         amIFunny amIFunnyInstance = new amIFunny(
            name, // name
            symbol, // symbol
            slug, // slug
            metadataFolderUri, // metadata folder uri
            mintsPerAddress, // mints per address
            contractMetadataUrl, // opensea contract metadata url
            isMintActive, // is mint active?
            validSigner
        );

        vm.stopBroadcast();
    }
}
