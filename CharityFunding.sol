// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract CharityContract {

    mapping(address => uint256) public _donor;
    address payable _childCharity;
    address  payable _houseCharity;
    uint256 public _targetAmount;
    uint256 public _AmountDonated;
    bool public active;

    constructor(address childCharity, address houseCharity, uint256 targetAmount) {
        childCharity = _childCharity;
        houseCharity = _houseCharity;
        targetAmount = _targetAmount;

    }

    function donate() external payable {
        require(active, "Thank you, we are not receiving donation at the moment");
        //msg.sender is the address of the wallet calling the function
        //money donaed will go to msg.valus anb be saved there
        _donor[msg.sender] += msg.value;

        if (_AmountDonated >= _targetAmount) {
  
            active = false;
        }
    }

    function withdraw() external {
        _childCharity.transfer(7 ether);
        _houseCharity.transfer(3 ether);

    }
}
