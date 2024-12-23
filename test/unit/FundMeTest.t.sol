// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {NetworkConstants} from "../../lib/NetworkConstants.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address immutable USER = makeAddr("USER");
    uint256 immutable USER_BALANCE = 1 ether;
    uint256 immutable SEND_VALUE = 0.1 ether;

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, USER_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5 * 1e18, "Incorrect minimum USD value");
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender, "Incorrect owner");
    }

    function testPriceFeedVersion() public view {
        uint256 expectedFundMeVersion;
        if (block.chainid == NetworkConstants.MAINNET_CHAIN_ID) {
            expectedFundMeVersion = 6;
        } else {
            expectedFundMeVersion = 4;
        }
        assertEq(fundMe.getVersion(), expectedFundMeVersion, "Incorrect price feed version");
    }

    function testFundFailsIfNotEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // the next TX will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        assertEq(SEND_VALUE, fundMe.getAddressToAmountFunded(USER), "Incorrect amount funded");
    }

    function testAddFunderToArrayOfFunders() public {
        vm.prank(USER); // the next TX will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        assertEq(USER, fundMe.getFunder(0), "Incorrect funder");
    }

    function testNonOwnerCantWithdrawWhenFundsExist() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testNonOwnerCantWithdrawWhenNoFundsExist() public {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testOwnerCanWithdrawWhenSingleFounder() public funded {
        address owner = fundMe.getOwner();
        uint256 initialOwnerBalance = owner.balance;
        uint256 initialContractBalance = address(fundMe).balance;

        vm.prank(owner);
        fundMe.withdraw();

        assertEq(
            initialOwnerBalance + initialContractBalance, owner.balance, "Incorrect owner balance after withdrawal"
        );
        assertEq(0, address(fundMe).balance, "Incorrect contract balance after withdrawal");
    }

    function testOwnerCanWithdrawWhenMultipleFounder() public funded {
        uint8 userCount = 5;
        for (uint160 i = 1; i <= userCount; i++) {
            address user = address(i);
            hoax(user, SEND_VALUE * i);
            fundMe.fund{value: SEND_VALUE}();
        }

        address owner = fundMe.getOwner();
        uint256 initialOwnerBalance = owner.balance;
        uint256 initialContractBalance = address(fundMe).balance;

        vm.prank(owner);
        fundMe.withdraw();

        assertEq(
            initialOwnerBalance + initialContractBalance, owner.balance, "Incorrect owner balance after withdrawal"
        );
        assertEq(0, address(fundMe).balance, "Incorrect contract balance after withdrawal");
    }

    function testOwnerCanWithdrawWhenNoFunders() public {
        address owner = fundMe.getOwner();
        uint256 initialOwnerBalance = owner.balance;

        vm.prank(owner);
        fundMe.withdraw();

        assertEq(initialOwnerBalance, owner.balance, "Incorrect owner balance after withdrawal");
        assertEq(0, address(fundMe).balance, "Incorrect contract balance after withdrawal");
    }
}
