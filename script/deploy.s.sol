// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "../src/GenericPfp.sol";

contract DeployGenericPfp is Script {
    function run() external {
        vm.startBroadcast();

        // use a different address if the chain is mainnet
        address validSigner = block.chainid == 1 ? 0xF04284F4470230b4f19C1dCa4FC9cd0f93170Ba6 : 0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f;

        uint256 mintsPerAddress = block.chainid == 1 ? 1 : 1000;
        bool isMintActive = block.chainid == 1 ? false : true;
        address metagameAddress = 0x9D8395A406FA264DeA71671c772269e844264E8C; // TODO Update this address

         genericPfp genericPfpInstance = new genericPfp(
            "Generic Avatar", // name
            "AVTR", // symbol
            "generic-pfp", // slug
            "https://core.themetagame.xyz/api/metadata/", // metadata folder uri
            mintsPerAddress, // mints per address
            "https://core.themetagame.xyz/api/contract-metadata/", // opensea contract metadata url
            isMintActive, // is mint active?
            validSigner,
            metagameAddress
        );

        vm.stopBroadcast();
    }
}
