// SPDX-License-Identifier: MIT
// Quick and Dirty EVM Bridge Vulnerability Demonstration (Pricing Mechanism)
// Based partially on the FIO <> EVM bridge utlitizing a single oracle with no custodian or middleware
// ERC20 Token/Wrapping https://github.com/fioprotocol/fio.erc20/blob/main/contracts/wfio.sol
// FIO Escrow Contract https://github.com/fioprotocol/fio.contracts/blob/release/2.11.x/contracts/fio.escrow/fio.escrow.cpp
// Oracle Middlware https://github.com/fioprotocol/fio.oracle

pragma solidity ^0.8.9;

contract MyBridge {
    address public oracle; // Single oracle for price feed
    mapping(address => uint256) public lockedAssets;
    mapping(address => uint256) public mintedTokens;
    uint256 public constant FEE = 1e16; // 0.01 ETH
    address public owner;

    event Escrow(address indexed user, uint256 amount, uint256 price);
    event Wrapped(address indexed user, uint256 amount);

    constructor(address _oracle) {
        oracle = _oracle;
        owner = msg.sender;
    }

    // Simulated oracle price fetch (vulnerable to manipulation)
    function getAssetPrice() public view returns (uint256) {
        return IOracle(oracle).getPrice();
    }

    function wrap(uint256 amount) external payable {
        require(msg.value >= FEE, "Insufficient fee");
        require(amount > 0, "Invalid amount");

        uint256 price = getAssetPrice();
        uint256 mintAmount = (amount * price) / 1e18; // Wrapped token representation

        lockedAssets[msg.sender] += amount;
        mintedTokens[msg.sender] += mintAmount;

        emit Escrow(msg.sender, amount, price);
        emit Wrapped(msg.sender, mintAmount);
    }

    function withdrawFees() external {
        require(msg.sender == owner, "Not an owner");
        payable(owner).transfer(address(this).balance);
    }
}

interface IOracle {
    function getPrice() external view returns (uint256);
}
