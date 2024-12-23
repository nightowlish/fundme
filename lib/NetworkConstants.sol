// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

library NetworkConstants {
    error NetworkConstants__ChainIdNotSupported();

    struct NetworkConfig {
        address priceFeed;
    }

    uint256 public constant MAINNET_CHAIN_ID = 1;
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ANVILE_CHAIN_ID = 31337;

    address public constant MAINNET_ETH_USD_CONFIG =
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
    address public constant SEPOLIA_ETH_USD_CONFIG =
        0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function chainIdToEthUsdConfig(
        uint256 chainId
    ) public pure returns (NetworkConfig memory) {
        if (chainId == MAINNET_CHAIN_ID) {
            return NetworkConfig(MAINNET_ETH_USD_CONFIG);
        } else if (chainId == SEPOLIA_CHAIN_ID) {
            return NetworkConfig(SEPOLIA_ETH_USD_CONFIG);
        } else {
            revert NetworkConstants__ChainIdNotSupported();
        }
    }
}
