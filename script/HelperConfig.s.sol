// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Constants} from "../lib/Constants.sol";

contract HelperConfig is Script {
    Constants.NetworkConfig public activePriceFeed;

    constructor() {
        address priceFeedAddress = Constants.chainIdToEthUsdConfig(
            block.chainid
        );
        activePriceFeed = Constants.NetworkConfig(priceFeedAddress);
    }
}
