// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)

pragma solidity 0.8.0;

import "./ArtToken.sol";
import "./Auction.sol";

contract AuctionFactory is Ownable{

    uint256 auctionIndex;

    mapping(uint256 => Auction) public auctionCollection;

    constructor()
    {
        auctionIndex = 0;
    }

    function createAuction(uint256 _bidIncrement, uint256 _startBlock, uint256 _endBlock, string memory _ntfHash) public
    {
        auctionCollection[auctionIndex] = new Auction(_bidIncrement, _startBlock, _endBlock, _ntfHash);
        auctionIndex = auctionIndex+1;
    }

    function getaActionByIndex(uint256 index) public view returns (Auction)
    {
        return auctionCollection[index];
    }

}