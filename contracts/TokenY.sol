// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../.deps/npm/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../.deps/npm/@openzeppelin/contracts/access/Ownable.sol";

contract TokenY is ERC20, Ownable {
    uint256 private myPrice;
    constructor() ERC20("TokenY", "TKY") {
        _mint(msg.sender, 10000 * 10 ** 18);
        myPrice = 10 ** 14; //price of tokenY is 0.0001 ETH
    }   
    function price() public view returns (uint256) {
        return myPrice;
    }
}
//tokenX 0x0A2DE82F4FF87Fa0e81942CBc368aF38F100594D
//tokenY 0x92EC42F7a9AaC2EF56e508Fa8Fa73F7cD634AB16
// ownerX 0x80e1bd688D0215EC43505d3705B4fd1A07B9aFa9
// ownerY 0xAe26d597f47674761282DAf6714b392F76368db9