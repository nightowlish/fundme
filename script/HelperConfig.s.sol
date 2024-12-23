// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activePriceFeed;
    uint256 private constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 private constant ANVILE_CHAIN_ID = 31337;

    error HelperConfig__ChainIdNotSupported();

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activePriceFeed = getSepoliaEthUsdConfig();
        } else if (block.chainid == ANVILE_CHAIN_ID) {
            activePriceFeed = getAnvileEthUsdConfig();
        } else {
            revert HelperConfig__ChainIdNotSupported();
        }
    }

    function getSepoliaEthUsdConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        NetworkConfig memory networkConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return networkConfig;
    }

    function getAnvileEthUsdConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        NetworkConfig memory networkConfig = NetworkConfig({
            priceFeed: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        });
        return networkConfig;
    }
}
