// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//what to build 
//a smat contract that allows a child to claim funds once 
//he or she is 18years old
// maximun amount is 1000 CELO
//function is a mixer
// improve the function to ensure you can withdraw 

contract ChildTrust {

    uint amount;

    address payable child; 
    
    address father;

    constructor(uint _amount, address payable _child) {
        amount = _amount;
        child = _child;
    }

    function withdraw() external payable {
        child.transfer(amount);
    }
}

