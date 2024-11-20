pragma solidity ^0.5.0;

import "./LotteryToken.sol";
import "./Lottery.sol";
import "./libraries/SafeMath.sol";

contract LotterySystem {
    using SafeMath for uint256;

    struct Charity {
        string name;
        bool verified;
        uint256 totalReceived; // amount the charity has received from this contract
    }

    // charity related
    address[] public CharityArray;
    address[] public pendingCharities; // Pending charities for verification
    mapping(address => Charity) public charityInfo; // charity data
    mapping(address => uint256) public charityAmounts;

    // lottery related
    Lottery[] public LotteryArray;
    LotteryToken public lotteryToken;
    Lottery.LotteryType lotterytype;
    // Lottery metalottery;
    mapping(uint8 => uint256) public price;   //enmu to price
    uint256[] public prizenum;

    //draw related
    Lottery[] public PrizeArray;
    uint256[] public PriceNum;
    uint256 prize;



    mapping(address => uint256[]) public userTickets;
    uint256 public purchaseDeadline;
    uint256 public drawTime;
    uint256 public prizepool;

    uint8 public prizePercentage;
    uint8 public ownerPercentage;
    uint8 public charityPercentage;
    uint8 public rolloverPercentage;

    address public owner;

    // charity related events
    event CharityJoined(string name, address indexed charityAddress);
    event CharityVerified(address indexed charityAddress, bool result);
    event CharityPaid(address indexed charity, uint256 amount);

    event TicketPurchased(
        address indexed buyer,
        uint256 value,
        address charity
    );
    event LotteryDrawn(uint256[] winningNumbers);
    event PrizePaid(address indexed winner, uint256 amount);
    event PrizePoolUpdated(uint256 newValue);
    event PercentagesUpdated(
        uint8 ownerCommission,
        uint8 charity,
        uint8 prize,
        uint8 rollover
    );


    event PrizePoolToppedUp(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier validCharity(address charityAddress) {
        require(
            charityInfo[charityAddress].verified,
            "This Charity is not verified"
        );
        _;
    }

    constructor(address _lotteryTokenAddress) public {
        lotteryToken = LotteryToken(_lotteryTokenAddress);
        owner = msg.sender;
        purchaseDeadline = now + 1 days;
        drawTime = purchaseDeadline + 1 hours;
        prizepool = 0;
        price[0]=5;
        price[1]=5;

        // Set default percentages
        ownerPercentage = 1;
        charityPercentage = 5;
        prizePercentage = 70;
        rolloverPercentage = 24;
    }

    function buyLottery(uint256 value,address charityAddress,uint8 times) public payable  {
        //require(charityInfo[charityAddress].verified,"This Charity is not verified");
        // create Lottery
        address buyer=msg.sender;
        // address payable ContractAddress=address(this);
        uint256 ticketprice=price[0];
        require(lotteryToken.getbalance(buyer) >= times*ticketprice,"No enough token to purchase,please topup first");
        // // loop to create each lottery for each purchase
        for(uint256 i=0;i<times;i++)
        {
            // we initalize only FourD first
            Lottery newLottery = new Lottery(Lottery.LotteryType.FourD,value,charityAddress,buyer);
            LotteryArray.push(newLottery);
            userTickets[buyer].push(value);
            // pay the price to the contract
            lotteryToken.transfer(owner,ticketprice);

            //set prizepool
            prizepool += ticketprice;
            
            // uint256 charityAmount = ticketprice.mul(charityPercentage).div(100);
            // charityAmounts[charityAddress] = charityAmounts[charityAddress].add(charityAmount);
            // prizepool = prizepool.add(ticketprice.sub(charityAmount));
        }

    }

    function draw(uint256 seed) public  {
        //random(seed)  select n number.
        prizenum.push(seed);
        //initial idea
        prizepool=prizepool/2;
        /*
        get the address of LotteryArray and xor the address of each contract
        require(lotteryArray.length > 0, "Lottery array is empty");

        // initial the Result
        uint256 xorResult = 0;

        // loop the Array to xor with the result
        for (uint256 i = 0; i < lotteryArray.length; i++) {
            xorResult ^= uint256(uint160(lotteryArray[i])); // 将 address 转为 uint256
        }

        // mod the result with 10 to get the randomNumber
        uint8 randomNumber = uint8(xorResult % 10);
        */
                //get the prize num and address of owner
        for(uint256 i=0;i<LotteryArray.length;i++)
        {
            for(uint256 j=0;j<prizenum.length;j++)
            {
                if(LotteryArray[i].getChosenNum()==prizenum[j])
                {
                    PrizeArray.push(LotteryArray[i]);
                }
            }
        }
        prize=prizepool/PrizeArray.length;  //ignore the float
        
    }

    function payprize() public payable  {

        for(uint256 i=0;i<PrizeArray.length;i++)
        {
            address payable winner=address(uint160(PrizeArray[i].getOwner()));
            winner.transfer(prize*0.001 ether);
        }

        
    }

    function getPrizeArray(uint256 index) public view returns(Lottery)
    {
        return PrizeArray[index];
    }

    function joinCharity(string memory name,address charityAddress) public onlyOwner {
        require(charityAddress != address(0), "Invalid charity address");
        require(!charityInfo[charityAddress].verified,"Charity already verified");

        charityInfo[charityAddress] = Charity(name, false, 0);
        emit CharityJoined(name, charityAddress);
    }

    function verifyCharity(
        address charityAddress,
        bool result
    ) public onlyOwner {
        require(
            !charityInfo[charityAddress].verified,
            "Charity already verified"
        );

        if (result) {
            charityInfo[charityAddress].verified = true;
            CharityArray.push(charityAddress);
        }

        emit CharityVerified(charityAddress, result);
    }

    // function payCharities() public onlyOwner {
    //     for (uint256 i = 0; i < CharityArray.length; i++) {
    //         address payable charityAddress = CharityArray[i];
    //         uint256 amount = charityAmounts[charityAddress];

    //         if (amount > 0) {
    //             charityAddress.transfer(amount);
    //             charityInfo[charityAddress].totalReceived = charityInfo[
    //                 charityAddress
    //             ].totalReceived.add(amount);
    //             charityAmounts[charityAddress] = 0; // Reset charity amount

    //             emit CharityPaid(charityAddress, amount);
    //         }
    //     }
    // }

    // Util functions

    function updatePercentage(
        uint8 _ownerCommission,
        uint8 _charity,
        uint8 _prize,
        uint8 _rollover
    ) public onlyOwner {
        uint8 totalPercentage = _ownerCommission +
            _charity +
            _prize +
            _rollover;
        require(totalPercentage == 100, "Percentages must sum to 100");

        ownerPercentage = _ownerCommission;
        charityPercentage = _charity;
        prizePercentage = _prize;
        rolloverPercentage = _rollover;

        emit PercentagesUpdated(_ownerCommission, _charity, _prize, _rollover);
    }

    function updateprizepool(uint256 value) public {
        require(msg.sender == owner, "Only owner can update prize pool");
        prizepool = value;
        emit PrizePoolUpdated(value);
    }

    function getPercentages() public view returns (uint8, uint8, uint8, uint8) {
        return (
            ownerPercentage,
            charityPercentage,
            prizePercentage,
            rolloverPercentage
        );
    }

    function getPoolDistribution()
        public
        view
        returns (
            uint256 ownerAmount,
            uint256 charityAmount,
            uint256 prizeAmount,
            uint256 rolloverAmount
        )
    {
        require(prizepool > 0, "Prize Pool is empty");
        uint256 totalAmount = prizepool;
        ownerAmount = totalAmount.mul(ownerPercentage).div(100);
        charityAmount = totalAmount.mul(charityPercentage).div(100);
        prizeAmount = totalAmount.mul(prizePercentage).div(100);
        rolloverAmount = totalAmount.mul(rolloverPercentage).div(100);
    }

    function getPurchaseDeadline() public view returns (uint256) {
        return purchaseDeadline;
    }

    function getDrawTime() public view returns (uint256) {
        return drawTime;
    }

    function getCharityInfo(
        address charityAddress
    )
        public
        view
        validCharity(charityAddress)
        returns (string memory, bool, uint256)
    {
        Charity memory charity = charityInfo[charityAddress];
        return (charity.name, charity.verified, charity.totalReceived);
    }

    function getUserTickets(
        address user
    ) public view returns (uint256[] memory) {
        return userTickets[user];
    }

    function topup(uint256 _amount) public payable returns(bool result)
    {
        uint256 requiredEther = _amount * lotteryToken.getTokenPrice();
        require(msg.value >= requiredEther, "Insufficient Ether sent");
        result=lotteryToken.topup(msg.sender,_amount);

        //transfer back
        if (msg.value > requiredEther) {
            msg.sender.transfer(msg.value - requiredEther);
        }
        return result;
    }

    function getLottery(uint256 index) public view returns(Lottery lot)
    {
        return LotteryArray[index];
    }

    function getPrize() public view returns(uint256)
    {
        return prize;
    }



}
