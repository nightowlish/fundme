// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5 * 1e18, "Incorrect minimum USD value");
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), address(this), "Incorrect owner");
    }

    function testPriceFeedVersion() public view {
        assertEq(fundMe.getVersion(), 4, "Incorrect owner");
    }
}
