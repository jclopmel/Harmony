// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)

pragma solidity 0.8.0;
 
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "./Ownable.sol";
 
contract ArtToken is NFTokenMetadata, Ownable {
  
  uint256 private index;
  
  constructor() {
    nftName = "Harmony NFT";
    nftSymbol = "HAR";
    index = 1;
  }

  function mint(address _to, string calldata _uri) external onlyOwner {
    super._mint(_to, index);
    super._setTokenUri(index, _uri);
    index = index+1;
  }
}