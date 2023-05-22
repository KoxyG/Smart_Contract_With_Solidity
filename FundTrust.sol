// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract FundTrust {
    uint public amount;
    address payable public child;
    address public father;
    uint public dueBlock;

    // Breakdown of the 18 years time space
    uint256 constant private BLOCKS_PER_DAY = 5760;
    uint256 constant private BLOCKS_PER_YEAR = 365 * BLOCKS_PER_DAY;
    uint256 constant private DURATION_18YEARS = 18 * BLOCKS_PER_YEAR;

    constructor(address payable _child) {
        child = _child;
        father = msg.sender; // Set the contract deployer as the father
    }

    function deposit() external payable {
        require(msg.sender == father, "Only the father can access this function.");
        amount += msg.value;
        dueBlock = block.number + DURATION_18YEARS;
    }

    function withdraw() external {
        require(msg.sender == child, "Only the child can access this function.");
        require(block.number >= dueBlock, "Funds are locked until the child reaches 18 years.");

        uint amountToTransfer = amount; // Store the amount to transfer
        amount = 0;
        dueBlock = 0;

        child.transfer(amountToTransfer);

    }
}

