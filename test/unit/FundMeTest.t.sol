// SPDX-Licence-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundMe = new FundMe(1O8GqCF48IYRdsnZhI5ZZpOaeLGCn5Dh);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwnerIsMsgSender() public view {      
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded () {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawlWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.i_owner()); 
        fundMe.withdraw();
        // Assert
        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawlFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();
        vm.stopPrank();
        // Assert
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.i_owner().balance);
    }

    function testWithdrawlFromMultipleFundersCheaper() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.i_owner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();
        // Assert
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.i_owner().balance);
    }


    // What can we do to work with addresses outside your system?
    // 1. Unit
    //     - Testing a specific part of our code
    // 2. Integration
    //     - Testing how our code works with other parts of our code.
    // 3. Forked
    //     - Testing our code on a simulated real environment.
    // 4. Staging
    //     - Testing our code in a real environment that is not prod.

}
