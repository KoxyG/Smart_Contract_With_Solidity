// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// A voter smart contract that allows people to add proposal
// anyone can vote yes or no
// after 1 day the proposal can be executed
// You have to be a member to vote


// proposal -> List[Proposal] -. {description, amount, vote, status}
// members -> List[address]

contract VoterContract {

    struct Proposal {
        address proposer;
        address receiver;
        string description;
        uint256 amount;
        uint256 yes;
        uint256 no;
        bool executed;
        uint256 deadLine;

    }

    mapping (uint256 => Proposal) _proposals;
    //mapping is an array
    //if it is true then a proposal is created
    //else it is not true then return false.
    
    uint256 _proposalsCount;

    mapping (address => bool) _members;
    // mapping an array, if address is true
    // then a member has been created
    // else, not created

    mapping (address => uint256) _voted;

    address admin;

    constructor() {
        //the deployer of the contract is our admin
        admin = msg.sender;
        require(msg.sender == admin, "You are not the admin imposter!!!!");
        
    }

    function addProposal(address receiver, string memory description, uint256 amount) external  {
        //when working with an argument or parameter you save, string memory.
        //this is saved in a string memory

        _proposals[_proposalsCount++] = Proposal(msg.sender, receiver, description, amount, 0, 0, false, block.timestamp + 1 days);
    }

    function vote(uint256 id, bool decision) external  {
        require(_proposals[id].deadLine > block.timestamp, "deadline exceeded");
        require(_voted[msg.sender] != id, "You have already voted before");

        if(decision) {
            _proposals[id].yes += 1;
        } else {
            _proposals[id].no += 1;
        }

        _voted[msg.sender] = id;

    }

    function execute(uint256 id) external {
        require(block.timestamp > _proposals[id].deadLine, "deadline not exceeded");
        require(_proposals[id].executed == false, "proposal excuted already");

        _proposals[id].executed = true;
        /// if true send the amount specified in the proposal to the proposer

        if (_proposals[id].amount > 0) {
        payable(_proposals[id].proposer).transfer(_proposals[id].amount);
    }
    }

    function addMember(address member) external {
        require(msg.sender == admin, "Not an admin");
        _members[member] = true;
    }

    function removeMember(address member) external  {
        require(msg.sender == admin, "Not an admin");
        _members[member] = false;
    }


}
