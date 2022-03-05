// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)

pragma solidity 0.8.0;
 
import "@openzeppelin/contracts/token/ERC20/Extensions/ERC20PresetFixedSupply.sol";
import "./Ownable.sol";
 
contract EToken is ERC20PresetFixedSupply {
	
    constructor() ERC20PresetFixedSupply( "ECOin", "ECO") {
    }
}