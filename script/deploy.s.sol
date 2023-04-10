// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "../src/GenericPfp.sol";

contract DeployGenericPfp is Script {
    function run() external {
        vm.startBroadcast();

        string memory name = "Vanderbilt Commodores";
        string memory symbol = "VANDY";
        string memory slug = "commodore";

        // string memory name = "Llama Pfp";
        // string memory symbol = "LMAPFP";
        // string memory slug = "llama-pfp";

        // string memory name = "Robo Nova";
        // string memory symbol = "RBNVA";
        // string memory slug = "robo-nova";

        // string memory name = "CDMX Axolotls";
        // string memory symbol = "AXTL";
        // string memory slug = "cdmx-axolotls";



        bool isMainnet = block.chainid == 1;

        // use a different address if the chain is mainnet
        address validSigner = isMainnet ? 0xF04284F4470230b4f19C1dCa4FC9cd0f93170Ba6 : 0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f;

        uint256 mintsPerAddress = isMainnet ? 1 : 1000;
        bool isMintActive = isMainnet ? false : true;
        address metagameAddress = 0x9D8395A406FA264DeA71671c772269e844264E8C; // TODO Update this address
        string memory metadataFolderUri = isMainnet ? "https://avatar-studio.xyz/api/metadata/" : "https://dev.avatar-studio.xyz/api/metadata/";
        string memory contractMetadataUrl = isMainnet ? "https://avatar-studio.xyz/api/contract-metadata/" : "https://dev.avatar-studio.xyz/api/contract-metadata/";

         genericPfp genericPfpInstance = new genericPfp(
            name, // name
            symbol, // symbol
            slug, // slug
            metadataFolderUri, // metadata folder uri
            mintsPerAddress, // mints per address
            contractMetadataUrl, // opensea contract metadata url
            isMintActive, // is mint active?
            validSigner,
            metagameAddress
        );

        vm.stopBroadcast();
    }
}
