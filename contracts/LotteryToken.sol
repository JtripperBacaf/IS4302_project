pragma solidity ^0.5.0;

import "./ERC20.sol";

contract LotteryToken is ERC20 {
    uint256 public INITIAL_SUPPLY = 1000000;
    uint256 public LT_PRICE = 0.001 ether;   // token price in ether
    address public owner;

    event TopupEvent(address indexed purchaser, uint256 amount);

    constructor() public ERC20("LotteryToken", "LT", 18, INITIAL_SUPPLY) {
        owner = msg.sender;
    }

    function topup(uint256 _amount) public payable returns (bool success) {
        uint256 requiredEther = _amount * LT_PRICE;
        require(msg.value >= requiredEther, "Insufficient Ether sent");

        // Transfer tokens to purchaser
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;

        emit TopupEvent(msg.sender, _amount);

        if (msg.value > requiredEther) {
            msg.sender.transfer(msg.value - requiredEther);
        }

        return true;
    }
}