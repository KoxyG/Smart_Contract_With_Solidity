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
    uint256 public childBirthday;
    uint256 public childCurrentAge;
    uint256 public dueDate;

    uint256 constant private SECONDS_PER_DAY = 24 * 60 * 60;
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
        require(childCurrentAge >= DURATION_18YEARS, "Funds are unlocked until the child reaches 18years");
        _;
    }

    
    constructor(address payable _child, uint _childBirthday) payable {
        //child's birthday should be provided in seconds 
        require(_childBirthday < block.timestamp, "Invalid child birthday");
        require(msg.value > 0, "Zero ETH not allowed");
        
        child = _child;
        amount = msg.value;
        father = msg.sender;

        //calculate the child's current age by subtracting from the current time
        childCurrentAge = block.timestamp - _childBirthday;
        childBirthday = _childBirthday;
    }

    function deposit() external payable onlyFather {
        require(msg.value > 0, "Zero ETH not allowed");
        amount += msg.value;
    }

    function withdraw() external payable onlyChild fundUnlocked {
        uint256 amountToSend = amount;
        amount = 0;

        child.transfer(amountToSend);
    }
}


