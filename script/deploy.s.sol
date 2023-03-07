// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "../src/GenericPfp.sol";

contract DeployGenericPfp is Script {
    function run() external {
        vm.startBroadcast();

        bool isMainnet = block.chainid == 1;

        // use a different address if the chain is mainnet
        address validSigner = isMainnet ? 0xF04284F4470230b4f19C1dCa4FC9cd0f93170Ba6 : 0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f;

        uint256 mintsPerAddress = isMainnet ? 1 : 1000;
        bool isMintActive = isMainnet ? false : true;
        address metagameAddress = 0x9D8395A406FA264DeA71671c772269e844264E8C; // TODO Update this address
        string memory metadataFolderUri = "https://dev.avatar-studio.xyz/api/metadata/";
        string memory contractMetadataUrl = "https://dev.avatar-studio.xyz/api/contract-metadata/";

         genericPfp genericPfpInstance = new genericPfp(
            "Robo Nova", // name
            "RBNVA", // symbol
            "robo-nova", // slug
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
