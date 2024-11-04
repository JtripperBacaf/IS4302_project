pragma solidity ^0.5.0;

import "./LotteryToken.sol";
import "./Lottery.sol";

contract LotterySystem {
    Lottery[] public LotteryArray;
    LotteryToken public lotteryToken;
    uint256[] public prizenum;

    address[] public CharityArray;
    address[] public pendingCharities;
    mapping(address => uint256) public charityamount;

    uint256 public purchaseDeadline;
    uint256 public drawTime;
    uint256 public prizepool;
    
    address public owner;


    event TicketPurchased(address indexed buyer, uint256 value, address charity);
    event CharityJoined(string name, address indexed charityAddress);
    event CharityVerified(address indexed charityAddress, bool result);
    event LotteryDrawn(uint256[] winningNumbers);
    event PrizePaid(address indexed winner, uint256 amount);
    event CharityPaid(address indexed charity, uint256 amount);
    event PrizePoolUpdated(uint256 newValue);
    event PrizePoolToppedUp(uint256 amount);

    constructor(address _lotteryTokenAddress) public{
        lotteryToken = LotteryToken(_lotteryTokenAddress);
        owner = msg.sender;
        purchaseDeadline = now + 1 days;
        drawTime = purchaseDeadline + 1 hours;
        prizepool = 0;
    }


    function buyLottery(uint256 value, address charity) public{

    }

    function joinCharity(string memory name, address caddress) public returns (bool) {

    }

    function verifyCharity(address caddress, bool result) public returns (bool) {
    
    }

    function draw() public returns (uint256[] memory) {

    }

    function payprize() public {

    }

    function paycharity() public {

    }

    function updateprizepool(uint256 value) public {
        require(msg.sender == owner, "Only owner can update prize pool");
        prizepool = value;
        emit PrizePoolUpdated(value);
    }

    function getPurchaseDeadline() public view returns (uint256) {return purchaseDeadline;}
    function getDrawTime() public view returns (uint256) {return drawTime;}



}