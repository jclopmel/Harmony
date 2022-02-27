// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)

pragma solidity 0.8.0;

import "./ERC721.sol";
import "./Ownable.sol";

/**
* Generates a no-fungible token which is going to be adquired only with AuctionToken
*/ 
contract ArtToken is ERC721, Ownable {

    mapping (uint256 => string) public artData;

    constructor(string memory name_, string memory symbol_) ERC721 (name_, symbol_)
    {
    }

    function mint (address receiver, uint256 tokenId, string memory artData) onlyOwner public returns(bool)
    {
        ERC721._safeMint(msg.sender, tokenId);
        artData[tokenId] = artData;
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    // GETTERS
}