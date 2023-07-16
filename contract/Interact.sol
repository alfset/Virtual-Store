// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductInventory {
    address public owner;
    mapping(uint256 => Product) public products;
    uint256 public totalProducts;
    mapping(address => uint256) public balances;

    struct Product {
        uint256 productId;
        string name;
        uint256 price;
        uint256 stockQuantity;
    }

    event ProductAdded(uint256 indexed productId, string name, uint256 price, uint256 stockQuantity);
    event FundingReceived(address indexed funder, uint256 amount);
    event Refunded(address indexed recipient, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addProduct(string memory name, uint256 price, uint256 stockQuantity) public onlyOwner {
        require(bytes(name).length > 0, "Product name cannot be empty");
        require(price > 0, "Price must be greater than zero");
        require(stockQuantity > 0, "Stock quantity must be greater than zero");

        totalProducts++;
        products[totalProducts] = Product(totalProducts, name, price, stockQuantity);

        emit ProductAdded(totalProducts, name, price, stockQuantity);
    }

    function fund() public payable {
        require(msg.value > 0, "Funding amount must be greater than zero");
        balances[msg.sender] += msg.value;

        emit FundingReceived(msg.sender, msg.value);
    }

    function refund(address recipient, uint256 amount) public onlyOwner {
        require(amount > 0, "Refund amount must be greater than zero");
        require(balances[recipient] >= amount, "Insufficient balance for refund");

        balances[recipient] -= amount;
        payable(recipient).transfer(amount);

        emit Refunded(recipient, amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        require
