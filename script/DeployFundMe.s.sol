// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract Deploy_FundMe is Script {
    function run() external returns (FundMe) {
        FundMe fundMe;
        HelperConfig helperConfig = new HelperConfig();
        address ethUSDpricefeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        fundMe = new FundMe(ethUSDpricefeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
