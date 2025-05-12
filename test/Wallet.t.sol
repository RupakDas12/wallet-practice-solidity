// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.29;

import "forge-std/Test.sol";
import "src/Wallet.sol";

contract WalletTest is Test {
    Wallet public wallet;
    
    address public owner = address(1);
    address public user = address(2);

    function setUp() public {
        vm.prank(owner);
        wallet = new Wallet();
    }

    function testOwner() public {
        assertEq(wallet.owner(), owner, "Owner should be set correctly");
    }

    function testDeposit() public {
        vm.deal(user, 1 ether);
        vm.prank(user);
        wallet.deposit{value: 1 ether}();
        assertEq(wallet.checkBalance(), 1 ether, "Deposit should be successful");
    }

    function testWithdraw() public {
        vm.deal(owner, 2 ether); // Funding owner
        vm.prank(owner);
        wallet.deposit{value: 2 ether}();

        vm.prank(owner);
        wallet.withdraw(1 ether);

        assertEq(wallet.checkBalance(), 1 ether, "Balance should be 1 ether after withdrawal");
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.deal(owner, 1 ether); // Funding owner
        vm.prank(owner);
        wallet.deposit{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert("Only owner can withdraw"); // Corrected error message
        wallet.withdraw(0.5 ether);
    }

    function testWithdrawInsufficientBalance() public {
        vm.deal(owner, 0.2 ether); // Funding owner
        vm.prank(owner);
        wallet.deposit{value: 0.2 ether}();

        vm.prank(owner);
        vm.expectRevert("Insufficient balance");
        wallet.withdraw(1 ether);
    }
}