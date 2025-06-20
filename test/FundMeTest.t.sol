// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "src/FundMe.sol";
import {Deploy_FundMe} from "script/DeployFundMe.s.sol";

contract Test_FundeMe is Test {
    FundMe fundMe;
    Deploy_FundMe deploy_fundMe;
    address constant USER = address(12345);
    uint256 constant STARTING_BALANCE = 10e18;
    uint256 constant SEND_VALUE = 5e18 / 2000; // 5 usd when deployed on anvil since 1ETH -> 2000USD

    function setUp() external {
        deploy_fundMe = new Deploy_FundMe();
        fundMe = deploy_fundMe.run();

        vm.deal(USER, STARTING_BALANCE);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function test_MINIMUM_USD() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_pricefeed_version() public view {
        uint version = 4;
        if (block.chainid == 1) {
            version = 6;
        }
        assertEq(fundMe.getVersion(), version);
    }

    // function testFundFailsWithoutEnoughETH() public {
    //     vm.prank(USER);
    //     vm.expectRevert();
    //     fundMe.fund{value: SEND_VALUE - 1}();
    // }

    function testFundUpdatesTheStorageVariables() public funded {
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE);
    }

    function testFunderAddedToArrayOfFunders() public funded {
        address addressOfFunder1 = fundMe.getFunderAtIndex(0);
        assertEq(addressOfFunder1, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawSuccessful() public funded {
        assertEq(address(fundMe).balance, SEND_VALUE);
        vm.prank(msg.sender);
        fundMe.withdraw();
        vm.expectRevert();
        fundMe.getFunderAtIndex(0); // s_funders[] is an empty array so trying to access 0th index will be out of bounds
        assertEq(address(fundMe).balance, 0);
    }

    function testWithdrawalWithoutFunds() public {
        vm.expectRevert();
        vm.prank(msg.sender);
        fundMe.withdraw();
    }
}
