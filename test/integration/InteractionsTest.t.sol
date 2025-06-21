// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {Deploy_FundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    Deploy_FundMe deploy_fundMe;
    address USER = makeAddr("USER");
    uint256 constant STARTING_BALANCE = 10e18;
    uint256 private constant SEND_VALUE = 0.1 ether;

    function setUp() external {
        deploy_fundMe = new Deploy_FundMe();
        fundMe = deploy_fundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.run();
        assertNotEq(address(fundMe).balance, 0);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.run();
        assertEq(address(fundMe).balance, 0);
    }
}
