// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../BlockLander.sol";
import "forge-std/console.sol";

contract blockLanderTest is Test {
    address constant owner = 0x44C489197133D7076Cd9ecB33682D6Efd271c6F7;

    uint private immutable signerPk = 1;
    address private immutable signer = vm.addr(1);

    address constant alice = 0x9bEF1f52763852A339471f298c6780e158E43A68;
    address constant bob = 0xFFff0BE2f91F2B4a5c22aEBbd928A9565EE92ccb;
    
    uint256 aliceValIndex = 69;
    uint256 bobValIndex = 420;

    // hardcoded from metabot API
    bytes32 r;
    bytes32 s;
    uint8 v;

    bytes32 r2;
    bytes32 s2;
    uint8 v2;

    // mint price = 777
    uint256 mintPrice = .000777 ether;

    blockLander blockLanderContract;

    constructor() {
        vm.prank(owner);
        blockLanderContract = new blockLander(
            "blockLander",
            "PFP",
            "generic-pfp",
            "NOT_IMPLEMENTED",
            1,
            "NOT_IMPLEMENTED",
            false,
            signer
        );

        bytes32 DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256("generic-pfp"),
                keccak256("1"),
                block.chainid,
                blockLanderContract.getAddress()
            )
        );

        // Alice
        bytes32 payloadHash = keccak256(abi.encode(DOMAIN_SEPARATOR, alice, aliceValIndex));
        bytes32 messageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", payloadHash)
        );
        (v,r,s) = vm.sign(signerPk, messageHash);

        //Bob
        bytes32 payloadHash2 = keccak256(abi.encode(DOMAIN_SEPARATOR, bob, bobValIndex));
        bytes32 messageHash2 = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", payloadHash2)
        );
        (v2,r2,s2) = vm.sign(signerPk, messageHash2);
        
    }

    function setUp() public {
        vm.prank(owner);
        blockLanderContract.setMintActive(true);
    }

    function testFailSetActiveByNonOwner() public {
        vm.prank(alice);
        blockLanderContract.setMintActive(true);
    }

    function testMintWithSignature() public {
        vm.deal(alice, 100000000000000000);
        vm.prank(alice);

        uint256 newTokenId = blockLanderContract.mintWithSignature{value:mintPrice}(alice, aliceValIndex, v, r, s);
        assertEq(newTokenId, 1);
    }

    function testCannotMintTwice() public {
        vm.deal(alice, 100000000000000000);
        vm.prank(alice);
        blockLanderContract.mintWithSignature{value:mintPrice}(
            alice,
            aliceValIndex,
            v,
            r,
            s
        );
        vm.deal(bob, 100000000000000000);
        vm.prank(bob);
        vm.expectRevert("only 1 mint per validator index");
        blockLanderContract.mintWithSignature{value:mintPrice}(
            bob,
            aliceValIndex,
            v,
            r,
            s
        );
    }

    function testMustMintForYourself() public {
        vm.deal(owner, 100000000000000000);
        vm.expectRevert("you have to mint for yourself");
        vm.prank(owner);
        blockLanderContract.mintWithSignature{value:mintPrice}(
            alice,
            aliceValIndex,
            v,
            r,
            s
        );
    }

    function testMustPay777() public {
        vm.deal(alice, 100000000000000000);
        vm.expectRevert('minting fee is 0.000777');
        vm.prank(alice);
        blockLanderContract.mintWithSignature(
            alice,
            aliceValIndex,
            v,
            r,
            s
        );
    }

    function testCannotFakeSignature() public {
        address newSigner = owner;
        vm.prank(owner);
        blockLanderContract.setValidSigner(newSigner);

        vm.deal(alice, 100000000000000000);
        vm.expectRevert(bytes("Invalid signer"));
        vm.prank(alice);
        blockLanderContract.mintWithSignature{value:mintPrice}(
            alice,
            aliceValIndex,
            v,
            r,
            s
        );
    }

    function testMultipleMints() public {
        vm.deal(alice, 100000000000000000);
        vm.prank(alice);
        uint256 newTokenId = blockLanderContract.mintWithSignature{value:mintPrice}(alice, aliceValIndex, v, r, s);
        assertEq(newTokenId, 1);

        vm.deal(bob, 100000000000000000);
        vm.prank(bob);
        uint256 newTokenId2 = blockLanderContract.mintWithSignature{value:mintPrice}(bob, bobValIndex, v2, r2, s2);
        assertEq(newTokenId2, 2);
        assertEq(blockLanderContract.mintedCount(), 2);

        vm.prank(owner);
        blockLanderContract.withdraw();
        // check how much eth owner has
        assertEq(owner.balance, 0.001554 ether); 
    }
    
    function testNormalTransfer() public {
        vm.deal(alice, 100000000000000000);
        vm.prank(alice);
        blockLanderContract.mintWithSignature{value:mintPrice}(alice, aliceValIndex, v, r, s);
        vm.prank(alice);
        blockLanderContract.transferFrom(alice, bob, 1);
    }
}
