// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;



//A fundTrust smart contract for a child
//only the child should be capable of invoking the withdrawal function
//only the father should have the ability to deposit funds
//the child would not be able to withdraw until 18years
//constructor should set the amount, child address, and birthday.


contract FundTrust {
    uint public amount;
    address payable public child;
    address public father;
    uint public childBirthday;
    uint public dueTimeStamp;


    uint256 constant private SECONDS_PER_DAY = 86400;
    uint256 constant private SECOND_PER_YEAR = 365 * SECONDS_PER_DAY;
    uint256 constant private DURATION_18YEARS = 18 * SECOND_PER_YEAR;


    modifier onlyFather() {
        require(msg.sender == father, "Only the father can access this function.");
        _;
    }

    modifier onlyChild() {
        require(msg.sender == child, "Only the child can access this function.");
        _;
    }

    modifier fundUnlocked() {
        require(block.timestamp >= dueTimeStamp, "Funds are unlocked until the child reaches 18years");
        _;
    }

    
    constructor(uint _amount, address payable _child, uint _childBirthday) {
        //child's birthday should be provided in Unix timestamp
        require(_childBirthday > block.timestamp, "Invalid child birthday");
        

        amount = _amount;
        child = _child;
        childBirthday = _childBirthday;
        father = msg.sender;

        //calculae the dueTimeStamp based on the child's provided birthday
        dueTimeStamp = childBirthday + DURATION_18YEARS;

    }

    function deposit() external payable onlyFather {
        amount += msg.value;

    }

    function withdraw() external  onlyChild fundUnlocked {
        child.transfer(amount);
    }
}


