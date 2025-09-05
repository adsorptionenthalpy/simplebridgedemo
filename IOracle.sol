// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// IOracle Interface
interface IOracle {
    function getPrice() external view returns (uint256);
}

contract MockOracle is IOracle {
    address public priceFeedSource; // Simulated DEX price feed source
    uint256 public price;

    constructor(address _priceFeedSource) {
        priceFeedSource = _priceFeedSource;
        price = 1000e18; // $1000 scaled by 1e18
    }

    function getPrice() external view override returns (uint256) {
        return price;
    }

    function setPrice(uint256 _newPrice) external {
        price = _newPrice;
    }
}
