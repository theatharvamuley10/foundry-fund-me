// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "test/mock_aggregator/mockv3aggregator.sol";

contract HelperConfig is Script {
    address public activeNetworkConfig;

    uint8 public constant DECIMALS = 8; // Rafactoring Magic Numbers to improve readability
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaPriceFeedAddress();
        } else if (block.chainid == 44787) {
            activeNetworkConfig = getCeloPriceFeedAddress();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getEthMainnetPriceFeedAddress();
        } else {
            activeNetworkConfig = getAnvilMockPriceFeed();
        }
    }

    function getSepoliaPriceFeedAddress() private pure returns (address) {
        return address(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function getCeloPriceFeedAddress() private pure returns (address) {
        return address(0x7b298DA61482cC1b0596eFdb1dAf02C246352cD8);
    }

    function getEthMainnetPriceFeedAddress() private pure returns (address) {
        return address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }

    function getAnvilMockPriceFeed() private returns (address) {
        if (activeNetworkConfig != address(0)) {
            return activeNetworkConfig;
        }
        MockV3Aggregator mockPriceFeedAggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        return address(mockPriceFeedAggregator);
    }
}
