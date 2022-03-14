// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)

pragma solidity 0.8.0;

import "../Auction.sol";

contract AuctionTest{

    Auction auction;
    address owner;

    function beforeAll() public {
        auction = new Auction(1, 1, 99, "NFT 01");
        owner = auction.owner();
    }

    function testCanceled() public returns (bool)
    {
        return Assert.equal(auction.canceled(), false, "Auction is cancelled");
    }

    function testCancelAuction() public returns (bool)
    {
        return Assert.equal(auction.cancelAuction(), true, "Auction can not be cancelled");
    }

    function testStartBlock() public returns (bool)
    {
        return Assert.equal(auction.startBlock(), 1, "Start Block is not 1");
    }

    function testEndBlock() public returns (bool)
    {
        return Assert.equal(auction.endBlock(), 99, "End Block is not 99");
    }

    function testNtfHash() public returns (bool)
    {
        return Assert.equal(auction.ntfHash(), "NFT 01", "NFT Hash is not NFT 01");
    }

    function testOwner() public returns (bool)
    {
        return Assert.equal(auction.owner(), owner, "Owner is not who created it");
    }
   
}