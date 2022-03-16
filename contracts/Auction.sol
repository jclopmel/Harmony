// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)

pragma solidity 0.8.0;

import "./Ownable.sol";

contract Auction is Ownable{

    // static
    uint256 public bidIncrement;
    uint256 public startBlock;
    uint256 public endBlock;
    string public ntfHash;

    // state
    bool public canceled;
    uint256 public highestBindingBid;
    address public highestBidder;
    mapping(address => uint256) public fundsByBidder;
    bool ownerHasWithdrawn;

    event LogBid(address bidder, uint256 bid, address highestBidder, uint256 highestBid, uint256 highestBindingBid);
    event LogWithdrawal(address withdrawer, address withdrawalAccount, uint256 amount);
    event LogCanceled();

    // constructor()
    constructor(uint256 _bidIncrement, uint256 _startBlock, uint256 _endBlock, string memory _ntfHash)
    {
        bidIncrement = _bidIncrement;
        startBlock = _startBlock;
        endBlock = _endBlock;
        ntfHash = _ntfHash;
    }

    function getHighestBid() public view returns (uint256)
    {
        return fundsByBidder[highestBidder];
    }

    /**
    * In this example theperson who places the auction is the winner of same,
    * It Reject payments of 0 ETH
    * It calculates current bidder bid by total bid based on the current amount they've sent to the contract plus the new transaction value
    * if the user isn't willing to overbid the highest bid, transaction is not possible
    *
    */
    function placeBid() onlyNotOwner onlyAfterStart onlyBeforeEnd payable public returns (bool success)
    {
        require(msg.value > 0, "Bid has to be a positive value");

        uint256 newBid = fundsByBidder[msg.sender] + msg.value;

        require(newBid > highestBindingBid, "Bid has to be higher then highest big value");

        uint256 highestBid = fundsByBidder[highestBidder];

        fundsByBidder[msg.sender] = newBid;

        if (newBid <= highestBid) {
            highestBindingBid = min(newBid + bidIncrement, highestBid);
        } else {

            if (msg.sender != highestBidder) {
                highestBidder = msg.sender;
                highestBindingBid = min(newBid, highestBid + bidIncrement);
            }

            highestBid = newBid;
        }

        emit LogBid(msg.sender, newBid, highestBidder, highestBid, highestBindingBid);

        return true;
    }

    function min(uint256 a, uint256 b) private pure returns (uint256)
    {
        if (a < b){
            return a;
        }

        return b;
    }

    function cancelAuction() onlyOwner onlyBeforeEnd onlyNotCanceled public returns (bool success)
    {
        canceled = true;
        emit LogCanceled();

        return true;
    }

    /**
    * if the auction was canceled: everyone is allowed to withdraw their funds
    * in the case the auction finished without being canceled: auction's owner should be allowed to withdraw the highestBindingBid
    *
    * the highest bidder should only be allowed to withdraw the difference between their highest bid and the highestBindingBid
    * anyone who participated but did not win the auction is  allowed to withdraw their funds
    */
    function withdraw() onlyEndedOrCanceled public payable returns (bool success)
    {
        address withdrawalAccount;
        uint256 withdrawalAmount;

        if (canceled) {
            withdrawalAccount = msg.sender;
            withdrawalAmount = fundsByBidder[withdrawalAccount];

        } else {

            if (msg.sender == owner) {
                withdrawalAccount = highestBidder;
                withdrawalAmount = highestBindingBid;
                ownerHasWithdrawn = true;

            } else if (msg.sender == highestBidder) {
                withdrawalAccount = highestBidder;
                if (ownerHasWithdrawn) {
                    withdrawalAmount = fundsByBidder[highestBidder];
                } else {
                    withdrawalAmount = fundsByBidder[highestBidder] - highestBindingBid;
                }

            } else {
                withdrawalAccount = msg.sender;

                withdrawalAmount = fundsByBidder[withdrawalAccount];

                require(withdrawalAmount != 0, "You can not withdraw an empty amount");

                payable(msg.sender).transfer(withdrawalAmount);
                
                fundsByBidder[withdrawalAccount] -= withdrawalAmount;

                emit LogWithdrawal(msg.sender, withdrawalAccount, withdrawalAmount);
            }
        }


        return true;
    }

    modifier onlyAfterStart {
        require(block.number > startBlock, "Bid process has not started yet");
        _;
    }

    modifier onlyBeforeEnd {
        require(block.number < endBlock, "Bid process has already finished");
        _;
    }

    modifier onlyNotCanceled {
        require(!canceled, "Bid process has been canceled");
        _;
    }

    modifier onlyEndedOrCanceled {
        require(block.number > endBlock || canceled, "Bid process has not been canceled neither finished");
        _;
    }
}