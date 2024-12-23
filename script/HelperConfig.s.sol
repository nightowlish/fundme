// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Constants} from "../lib/Constants.sol";
import {MockV3Aggregator} from "mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    Constants.NetworkConfig public activePriceFeed;

    constructor() {
        if (block.chainid == Constants.ANVILE_CHAIN_ID) {
            activePriceFeed = getAnvileEthUsdConfig();
        } else {
            activePriceFeed = Constants.chainIdToEthUsdConfig(block.chainid);
        }
    }

    function getAnvileEthUsdConfig()
        public
        returns (Constants.NetworkConfig memory)
    {
        // Deploy mock priceFeed contract
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 3000e8);
        vm.stopBroadcast();

        return Constants.NetworkConfig(address(mockPriceFeed));
    }
}
