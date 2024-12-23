// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {NetworkConstants} from "../lib/NetworkConstants.sol";
import {MockV3Aggregator} from "mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConstants.NetworkConfig public activePriceFeed;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 3000e8;

    constructor() {
        if (block.chainid == NetworkConstants.ANVILE_CHAIN_ID) {
            activePriceFeed = getOrCreateAnvileEthUsdConfig();
        } else {
            activePriceFeed = NetworkConstants.chainIdToEthUsdConfig(block.chainid);
        }
    }

    function getOrCreateAnvileEthUsdConfig() public returns (NetworkConstants.NetworkConfig memory) {
        if (activePriceFeed.priceFeed != address(0)) {
            return activePriceFeed;
        }

        // Deploy mock priceFeed contract
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        return NetworkConstants.NetworkConfig(address(mockPriceFeed));
    }
}
