// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../ArtToken.sol";
 
contract ArtTokenTest {
  
    ArtToken artToken;
    address testAccount;

  function beforeAll() public {
      artToken = new ArtToken();
      address testAccount = msg.sender;
  }
  
  function testGetLastIndex() public returns (bool)
  {
      return Assert.equal(artToken.getLastIndex(), 1, "Index is not set at 1 value");
  }

  function testMint() public returns (bool)
  {
        artToken.mint(msg.sender, "exampleHash");
        return Assert.equal(artToken.getLastIndex(), 2, "Index is not set at 2 value");
  }

  function testGetNftName() public returns (bool)
  {
      return Assert.equal(artToken.getNftName(), "Harmony NFT", "NFT name is not Harmony NFT");
  }


  function testGetNftSymbol() public returns (bool)
  {
      return Assert.equal(artToken.getNftSymbol(), "HAR", "NFT symbol is not HAR");
  }
}