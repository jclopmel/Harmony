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

    function createAuction() public
    {
        auctionCollection[auctionIndex] = new Auction(1, 1, 999, "nfthash");
        auctionIndex = auctionIndex+1;
    }

}