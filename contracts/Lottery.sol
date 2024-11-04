pragma solidity ^0.5.0;

contract Lottery {
    enum LotteryType { TypeA, TypeB }
    LotteryType public lotteryType;
    uint256 public chosenNum;
    address public owner;

    constructor(LotteryType _lotteryType, uint256 _chosenNum) public {
        lotteryType = _lotteryType;
        chosenNum = _chosenNum;
        owner = msg.sender;
    }

    function getLotteryType() public view returns (LotteryType) {return lotteryType;}
    function getChosenNum() public view returns (uint256) {return chosenNum;}
    function getOwner() public view returns (address) {return owner;}
}