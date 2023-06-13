// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Token/smTokenInterface.sol";

contract MarketAnalyzer is Ownable {
    AggregatorV3Interface internal priceFeed;
    SMTokenInterface internal SMTToken;
    uint internal previousPrice = 0;

    error notSufficientBalance();

    event Sell(address indexed seller, uint256 amount);
    event Buy(address indexed buyer, uint256 amount);

    constructor(address _oracle, address _SMTToken) Ownable() {
        priceFeed = AggregatorV3Interface(_oracle);
        SMTToken = SMTokenInterface(_SMTToken);
    }

    //If the price goes up 1% it will notify the user to sell
    //else if the price goes down 1% it will notify the user to buy
    function decisionMaker() external {
        if (SMTToken.balanceOf(msg.sender) == 0) {
            revert notSufficientBalance();
        }
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 currentPrice = uint256(price);

        if (currentPrice >= previousPrice + (previousPrice / 100)) {
            SMTToken.transferFrom(msg.sender, owner(), 1);
            emit Sell(msg.sender, currentPrice);
            //we can also use dexes available on fantom network to swap linke 1inch or Sooky swap, unfortunataly I don't have any exprience in them, and also don't have enough time to complete this section so I choose to emit an event to buy or sell, and a bot which can be implemented with nodejs, would listen to events and then do some actions
            previousPrice = currentPrice;
        } else if (currentPrice <= previousPrice - (previousPrice / 100)) {
            SMTToken.transferFrom(msg.sender, owner(), 1);
            emit Buy(msg.sender, currentPrice);
            //we can also use dexes available on fantom network to swap linke 1inch or Sooky swap, unfortunataly I don't have any exprience in them, and also don't have enough time to complete this section so I choose to emit an event to buy or sell, and a bot which can be implemented with nodejs, would listen to events and then do some actions
            previousPrice = currentPrice;
        }
    }
}
