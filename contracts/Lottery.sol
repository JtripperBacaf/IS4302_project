pragma solidity ^0.5.0;

contract Lottery {
    enum LotteryType {
        FourD,
        TOTO
    }

    LotteryType public lotteryType;
    uint256 public chosenNum;
    address public charityAccount;
    address public owner;

    event CharitySet(address indexed charityAccount);

    constructor(
        LotteryType _lotteryType,
        uint256 _chosenNum,
        address _charityAccount
    ) public {
        require(_charityAccount != address(0), "Invalid charity address");

        lotteryType = _lotteryType;
        chosenNum = _chosenNum;
        charityAccount = _charityAccount;
        owner = msg.sender;

        emit CharitySet(_charityAccount);
    }

    function getLotteryType() public view returns (LotteryType) {
        return lotteryType;
    }

    function getChosenNum() public view returns (uint256) {
        return chosenNum;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getCharityAccount() public view returns (address) {
        return charityAccount;
    }

    function updateCharityAccount(address newCharityAccount) public {
        require(msg.sender == owner, "Only owner can update the charity");
        require(newCharityAccount != address(0), "Invalid charity address");

        charityAccount = newCharityAccount;
        emit CharitySet(newCharityAccount);
    }
}
