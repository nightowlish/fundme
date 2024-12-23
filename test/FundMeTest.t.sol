// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {Constants} from "../lib/Constants.sol";

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
        assertEq(fundMe.i_owner(), msg.sender, "Incorrect owner");
    }

    function testPriceFeedVersion() public view {
        uint256 expectedFundMeVersion;
        if (block.chainid == Constants.MAINNET_CHAIN_ID) {
            expectedFundMeVersion = 6;
        } else {
            expectedFundMeVersion = 4;
        }
        assertEq(
            fundMe.getVersion(),
            expectedFundMeVersion,
            "Incorrect price feed version"
        );
    }
}
