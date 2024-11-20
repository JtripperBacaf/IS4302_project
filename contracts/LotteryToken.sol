pragma solidity ^0.5.0;

import "./ERC20.sol";

contract LotteryToken is ERC20 {
    uint256 public INITIAL_SUPPLY = 1000000;
    uint256 public LT_PRICE = 0.001 ether;   // token price in ether
    address payable  public owner;

    event TopupEvent(address indexed purchaser, uint256 amount);

    constructor() public ERC20("LotteryToken", "LT", 18, INITIAL_SUPPLY) {
        owner = msg.sender;
    }


    //topup for a user
    function topup(address payable user,uint256 _amount) public payable returns (bool success) {
        //calculate the requiredEther
        // require(msg.value >= requiredEther, "Insufficient Ether sent");
        
        // Transfer tokens to purchaser

        balanceOf[user] += _amount;
        balanceOf[owner] -= _amount;
        totalSupply += _amount;


        emit TopupEvent(user, _amount);

        return true;
    }

    function getbalance(address user) public view  returns(uint256 amount)
    {
        return balanceOf[user];
    }

    function getTokenPrice() public view returns (uint256) 
    {
        return LT_PRICE; // 调用 LotteryToken 的 LT_PRICE
    }
}