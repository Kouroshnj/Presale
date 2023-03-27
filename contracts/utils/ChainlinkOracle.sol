// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract ChainlinkOracle {
    AggregatorV3Interface internal priceFeedBNB;
    AggregatorV3Interface internal priceFeedBUSD;

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */
    constructor() {
        priceFeedBNB = AggregatorV3Interface(
            0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526
        );
        priceFeedBUSD = AggregatorV3Interface(
            0x9331b55D9830EF609A2aBCfAc0FBCE050A52fdEa
        );
    }

    /**
     * Returns the latest price.
     */
    function getLatestPriceBNB() public view returns (uint256) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            uint price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeedBNB.latestRoundData();
        return price * 10 ** 10;
    }

    function getlatestCustomePrice() public pure returns (uint256) {
        uint256 price = 284694034390000000000;
        return price;
    }
}

// 290086380000000000000
// 870000000000000000000
