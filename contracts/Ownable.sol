// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)

pragma solidity 0.8.0;

contract Ownable {

    address public owner;

    constructor()
    {
        owner = msg.sender;
    }

    modifier onlyOwner()
    {
        require(owner == msg.sender);
        _;
    }
}