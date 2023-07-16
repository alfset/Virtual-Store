// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StockControl {
    address public owner;
    uint256 public stockLevel;

    struct Transaction {
        address buyer;
        uint256 quantity;
        uint256 timestamp;
    }

    Transaction[] public transactions;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to add stock quantity
    function addStock(uint256 quantity) public onlyOwner {
        require(quantity > 0, "Quantity must be greater than zero");
        stockLevel += quantity;
    }

    // Function to subtract stock quantity
    function subtractStock(uint256 quantity) public onlyOwner {
        require(quantity > 0, "Quantity must be greater than zero");
        require(stockLevel >= quantity, "Insufficient stock");
        stockLevel -= quantity;
    }

    // Function to get the current stock level
    function getStockLevel() public view returns (uint256) {
        return stockLevel;
    }

    // Function to record a transaction
    function recordTransaction(address buyer, uint256 quantity) public onlyOwner {
        require(quantity > 0, "Quantity must be greater than zero");
        require(stockLevel >= quantity, "Insufficient stock");

        transactions.push(Transaction(buyer, quantity, block.timestamp));
        stockLevel -= quantity;
    }

    // Function to generate a basic report of past transactions
    function generateReport() public view returns (Transaction[] memory) {
        return transactions;
    }
}
