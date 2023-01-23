// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../.deps/npm/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../.deps/npm/@openzeppelin/contracts/access/Ownable.sol";
import "../.deps/npm/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./TokenY.sol";

contract TokenX is ERC20, Ownable {
    uint256 private priceX;
    uint256 private priceY;
    address private ownerX;
    address private ownerY;
    TokenY private tokenY;
    address private chainlinkAddress;
    AggregatorV3Interface internal priceFeed;
    constructor(address _tokenY,address _ownerX,address _ownerY) ERC20("TokenX", "TKX") {
        _mint(msg.sender, 10000 * 10 ** 18);
        chainlinkAddress = 0x9F6d70CDf08d893f0063742b51d3E9D1e18b7f74;
        priceFeed = AggregatorV3Interface(chainlinkAddress);
        priceX =  10 ** 13; //price of tokenX is 0.00001 ETH
        tokenY = TokenY(_tokenY);
        ownerX = _ownerX;
        ownerY = _ownerY;
        priceY = tokenY.price();
    }

    function myPrice() public view returns (uint256) {
        return priceX;
    }

    function updatePriceX(uint256 newPriceX) public onlyOwner {     
        priceX = newPriceX;
    }

    function getLatestChainlinkPrice() public view returns (int priceChainlink) {
        (
        , 
        int price,
        ,
        ,
        ) = priceFeed.latestRoundData();
        return price;
    }
    
    function exchange(uint256 amountToExchange) public payable {
        require(amountToExchange > 0,"amount to be greater than 0");
        require(allowance(msg.sender,address(this)) >= (amountToExchange / priceX) * (10 ** 18),"your's allowance is low");
        require(tokenY.allowance(ownerY,address(this)) >= (amountToExchange / priceY) * (10 ** 18),"Token Y allowance too low");
        //Buying token from Y to X
        (bool buy) = tokenY.transferFrom(ownerY,msg.sender,((amountToExchange/priceY) * (10 ** 18)));
        require(buy, "Failed to buy token");
        //send to Y from X
        bool sent = transfer(ownerY,((amountToExchange / priceX) * (10 ** 18)));
        require(sent,"failed to send tokens");

    }

}
