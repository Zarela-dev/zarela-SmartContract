// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0 <0.8.0;
import "./ERC20.sol";
import "./ERC20Burnable.sol";

/// @author Zarela Team 
/// @title Decentralized marketplace platform for peer-to-peer transferring of Biosignals
contract ZarelaSmartContract is ERC20 , ERC20Burnable {
    
    
    constructor() {
        _mint(msg.sender , 4000000000000000);
        _mint(address(this) , 16000000000000000);
    }


    event OrderRegistered(
        address owner,
        uint Order_ID
        );
    event Contributed(
        address Contributer,
        uint Order_ID,
        address Requester,
        uint difficulty
        );
    event OrderFinished(
        uint Order_ID
        );
   
    uint public maxUserDailyReward = 50000000000; // Max User Daily Reward As BIOBIT + 50 + _decimals 
    uint public totalTokenReleaseDaily = 14400000000000; // Total Tokens That Release From Zarela Reward Pool Per Day 
    
    address payable[] public allAngelsAddresses; // All Angels Addresses Who Contributes In Zarela
    uint public halvingCounter; // Halving Counter
    uint public countDown24Hours = block.timestamp; // Starting 24 hours Timer By Block Timestamp (From Deploy Zarela)
    uint public dayCounterOf18Months; // Day Counter Of 18 Months (547 days  =  18 months )
    uint public indexCounter; // Index Of Entered Contributors Array 
    uint public lastRewardableIndex; // Index Of Last Person Who Should Get Reward Until Yesterday
    uint public indexOfAddressPendingReward; // Index Of allAngelsAddresses Array Pending For Reward
    address addressOfPendingReward; // Address Of allAngelsAddresses Array Pending For Reward
    uint public paymentDay; // Payment Day
    uint public todayContributionsCount; // Count Of Today Contributions
    uint[] public dailyContributionsCount; //  Count Of Daily Contributions
    uint public bankBalance; // The Amount of Tokens Remained and Can Add to Rewarding for Next Day
    uint[] public remainedDailyTokens; // Daily Token Remained
    uint indexOfZeroDailyTokens; // Index Of remainedDailyTokens Array That Before Day There is No Token
    uint public dayOfTokenBurning; // The Day That Token Will be Burned
    uint public zarelaDayCounter; // The Day Count Of Zarela Age
    uint[] public burnedTokensPerDay; // Array Of Burned Tokens Per Day
    uint[] public dailyRewardPerContributor; // Array Of Daily Reward Per Countributor
    uint[] public dailyBalance; // Array Of Daily Balance 
    uint public zarelaDifficultyOfDay; // The Difficulty Of Zarela Network Per Day
    bool public isZarelaEnd; // is Zarela End?
    
    struct Order {
        uint orderId; // Order ID
        string orderTitle; // Order Title
        address orderOwner; // Order Owner
        uint tokenPerContributor; // Allcoated Biobit Per Contributor
        uint totalContributors; // Total Contributors
        string zPaper; // zPaper
        string description; // Description Of Order
        uint totalContributorsRemain; // Total Contributors Remain
        uint countOfRegisteredContributions; // Count of Registered Contributions
        uint registrationTime; // Order Registration Time
        string encryptionKey;  // AES Encryption Key
    }
    
    struct Category {
        uint orderId; // Order ID
        string zarelaCategory; // Zarela Category (Hashtags)
        uint businessCategory; // Business Category
    }
    
    struct OrderData {
        uint orderId; // Order ID
        uint[] dataRegistrationTime;  // Data Registration Time
        string[] ipfsHash; //  Hash Of Data (Stored In IPFS)
        address[] contributorAddresses; // Array Of Contributors addresses
        bool[] isConfirmedByMage; // is Confirmed By Mage?
        uint[] zarelaDay; // in Which Zarela Day This Data is Imported
    }
    
    struct User {
        uint tokenGainedFromSC; // Total Tokens That User Gained From Smart Contract (Reward Pool)
        uint tokenGainedFromMages; // Total Tokens That User Gained From Mages
        uint[] contributedOrders; // Array Of Orderids That User is Contributed
        uint[] ownedOrders; // Array Of Order ids That User is Owned
    }
    
    mapping(uint => OrderData) orderDataMap;
    mapping(address => User) public userMap;
    Order[] public orders; 
    Category[] public categories;
    
    modifier onlyRequester(uint _Order_Number) {
        Order storage myorder = orders[_Order_Number];
        require(myorder.orderOwner == msg.sender, "You Are Not Owner");
        _;
    }
    
    modifier checkOrderId(uint _Order_Number) {
        Order storage myorder = orders[_Order_Number];
        require(_Order_Number == myorder.orderId , "This Order Number Is Not Correct");
        _;
    }
    
    modifier notNull(address _address) {
        require(address(0) != _address, "Send to the zero address");
        _;
    }
    
    /// @dev make any kind of request that may be answered with a file.This function is only called by Mage 
    function registerNewOrder(
        string memory _orderTitle,
        string memory _description,
        string memory _zPaper,
        uint _tokenPerContributor,
        uint _totalContributors,
        string memory _zarelaCategory
        ,string memory _encryptionKey
        ,uint _businessCategory
    )
        public
    {
        require(_balances[msg.sender] >= (_tokenPerContributor * _totalContributors) , "Your Token Is Not Enough");
        ERC20.transfer(address(this),(_tokenPerContributor * _totalContributors));
        uint orderId = orders.length;
        orders.push(
            Order(
                orderId,
                _orderTitle,
                msg.sender,
                _tokenPerContributor,
                _totalContributors,
                _zPaper,
                _description,
                _totalContributors,
                0,
                block.timestamp,
                _encryptionKey
                )
            );
        userMap[msg.sender].ownedOrders.push(orderId);
        categories.push(
            Category(
                orderId,
                _zarelaCategory,
                _businessCategory
                )
            );
        emit OrderRegistered(msg.sender, orderId);
        emit Transfer(msg.sender, address(this), (_tokenPerContributor * _totalContributors));
    }
    
    
    /// @dev Send the angel signal to mage and save then signal IPFS Hash in the block.Also, due to the difficulty of the Zarela network,
    /// each user pays the Reward to a number of people in the non-Reward queue
    function contribute(
        uint _orderId,
        address _orderOwner,
        string memory _ipfsHash
    )
        public 
        checkOrderId (_orderId)
        notNull(_orderOwner)
    {
        require(orders[_orderId].totalContributorsRemain != 0 ,"Order Was Finished");
        require(_orderOwner ==  orders[_orderId].orderOwner , "Requester Address Was Not Entered Correctly");
        
        if (isZarelaEnd != true) {
            if (block.timestamp < countDown24Hours + 24 hours) {
                allAngelsAddresses.push(msg.sender);
                todayContributionsCount++;
            } else {
                allAngelsAddresses.push(address(0));
                allAngelsAddresses.push(msg.sender);
                dailyContributionsCount.push(todayContributionsCount);
                if (dayCounterOf18Months >= 547) { //18 month
                    maxUserDailyReward = maxUserDailyReward / 2 ;
                    totalTokenReleaseDaily = totalTokenReleaseDaily / 2 ;
                    halvingCounter++;
                    dayCounterOf18Months = 0 ;
                }
                if ( _balances[address(this)] >= totalTokenReleaseDaily) {
                    _balances[address(this)] = _balances[address(this)] - totalTokenReleaseDaily;
                } else if (bankBalance > 0 && _balances[address(this)] < totalTokenReleaseDaily) {
                    bankBalance+= totalTokenReleaseDaily;
                    totalTokenReleaseDaily = 0; 
                } else {
                    totalTokenReleaseDaily = 0;
                    isZarelaEnd = true;
                }
                
                bankBalance+=(totalTokenReleaseDaily);
                remainedDailyTokens.push(totalTokenReleaseDaily);
                
                if (zarelaDayCounter >= 44) { // 45 days
                    bankBalance = bankBalance - (remainedDailyTokens[dayOfTokenBurning]);
                    burnedTokensPerDay.push(remainedDailyTokens[dayOfTokenBurning]);
                    remainedDailyTokens[dayOfTokenBurning] = 0;
                    dayOfTokenBurning++;
                }
                
                dailyBalance.push(bankBalance);
                
                if (maxUserDailyReward * dailyContributionsCount[zarelaDayCounter] >= bankBalance) {
                    dailyBalance[zarelaDayCounter] = bankBalance;
                    dailyRewardPerContributor.push(bankBalance/dailyContributionsCount[zarelaDayCounter]);
                    bankBalance = 0;
                } else {
                    dailyBalance[zarelaDayCounter] = maxUserDailyReward * dailyContributionsCount[zarelaDayCounter];
                    dailyRewardPerContributor.push(maxUserDailyReward);
                    bankBalance = bankBalance - (maxUserDailyReward * dailyContributionsCount[zarelaDayCounter]);
                }
               
                uint tempPrice = dailyBalance[zarelaDayCounter];
                
                if (tempPrice >= remainedDailyTokens[zarelaDayCounter]) {
                    tempPrice = tempPrice - (remainedDailyTokens[zarelaDayCounter]);
                    remainedDailyTokens[zarelaDayCounter] = 0;
                    while (tempPrice > 0) {
                        if (tempPrice > remainedDailyTokens[indexOfZeroDailyTokens]) {
                            tempPrice = tempPrice - (remainedDailyTokens[indexOfZeroDailyTokens]);
                            remainedDailyTokens[indexOfZeroDailyTokens] = 0;
                            indexOfZeroDailyTokens++;
                        } else {
                            remainedDailyTokens[indexOfZeroDailyTokens] =  remainedDailyTokens[indexOfZeroDailyTokens] - (tempPrice);
                            tempPrice = 0;
                        }
                    }
                } else {
                    remainedDailyTokens[zarelaDayCounter] = remainedDailyTokens[zarelaDayCounter] - tempPrice;
                }
                
                zarelaDifficultyOfDay = (lastRewardableIndex - indexOfAddressPendingReward) / dailyContributionsCount[zarelaDayCounter];
                
                if ((zarelaDayCounter - paymentDay) >= 7 && (lastRewardableIndex - indexOfAddressPendingReward) >= 384 ) {
                    zarelaDifficultyOfDay = 128;
                } else if (zarelaDifficultyOfDay < 5) {
                    zarelaDifficultyOfDay = 2**zarelaDifficultyOfDay;
                } else {
                    zarelaDifficultyOfDay = 32;
                }
                
                todayContributionsCount = 0;
                zarelaDayCounter++;
                dayCounterOf18Months++;
                countDown24Hours = block.timestamp;
    
            }
            if (allAngelsAddresses[indexCounter] == address(0)) {
                lastRewardableIndex = indexCounter;
                _reward();
                indexCounter+=2;
                todayContributionsCount++;
            } else if (lastRewardableIndex != indexOfAddressPendingReward) {
                _reward();
                indexCounter++;
            } else {
                indexCounter++;
            }
        }
        
        orderDataMap[_orderId].orderId = _orderId;
        orders[_orderId].countOfRegisteredContributions++;
        orderDataMap[_orderId].ipfsHash.push(_ipfsHash);
        orderDataMap[_orderId].contributorAddresses.push(msg.sender);
        orderDataMap[_orderId].isConfirmedByMage.push(false);
        orderDataMap[_orderId].dataRegistrationTime.push(block.timestamp);
        userMap[msg.sender].contributedOrders.push(_orderId);
        orderDataMap[_orderId].zarelaDay.push(zarelaDayCounter);

        emit Contributed(msg.sender ,_orderId ,_orderOwner ,zarelaDifficultyOfDay);
    }
    
    /// @dev Calculate and pay the Reward
    function _reward() private {
        uint temporary = indexOfAddressPendingReward;
        if (zarelaDifficultyOfDay == 128) {
            for (uint i= temporary; i < temporary + zarelaDifficultyOfDay; i++) {
                if (i >= lastRewardableIndex) {
                    break;
                }
                
                addressOfPendingReward = allAngelsAddresses[i];
                
                if (addressOfPendingReward == address(0)) {
                    paymentDay++;
                    i++;
                    indexOfAddressPendingReward++;
                    addressOfPendingReward = allAngelsAddresses[i];
                }
                
                _balances[addressOfPendingReward] = _balances[addressOfPendingReward] + ((dailyRewardPerContributor[paymentDay]));
                userMap[addressOfPendingReward].tokenGainedFromSC += (dailyRewardPerContributor[paymentDay]);
                indexOfAddressPendingReward++;
            }
        }
        if ((lastRewardableIndex - temporary) >= 16) {
            for (uint i = temporary  ; i < zarelaDifficultyOfDay + temporary ; i++) {
                if (i >= lastRewardableIndex) {
                    break;
                }
                
                addressOfPendingReward = allAngelsAddresses[i];
                
                if (addressOfPendingReward == address(0)) {
                    paymentDay++;
                    i++;
                    indexOfAddressPendingReward++;
                    addressOfPendingReward = allAngelsAddresses[i];
                }
                
                _balances[addressOfPendingReward] = _balances[addressOfPendingReward] + ((dailyRewardPerContributor[paymentDay]));
                userMap[addressOfPendingReward].tokenGainedFromSC += (dailyRewardPerContributor[paymentDay]);
                indexOfAddressPendingReward++;
            }
        } else if ((lastRewardableIndex - temporary) < 16) {
            for (uint i = temporary ; i < lastRewardableIndex ; i++) {
                addressOfPendingReward = allAngelsAddresses[i];
                if (addressOfPendingReward == address(0)) {
                    paymentDay++;
                    i++;
                    indexOfAddressPendingReward++;
                    addressOfPendingReward = allAngelsAddresses[i];
                }
                
                _balances[addressOfPendingReward] = _balances[addressOfPendingReward] + ((dailyRewardPerContributor[paymentDay]));
                userMap[addressOfPendingReward].tokenGainedFromSC += (dailyRewardPerContributor[paymentDay]);
                indexOfAddressPendingReward++;
            }
        }
    }
    
    /// @dev Confirm the signals sent by angels only by Requester (Mage) of that signal.
    /// The selection of files is based on their index.
    function confirmContributer(
        uint _orderId,
        uint[]memory _Index
    )
        public 
        onlyRequester (_orderId)
        checkOrderId(_orderId)
    {
        Order storage myorder = orders[_orderId];
        require(_Index.length <= myorder.totalContributorsRemain,"The number of entries is more than allowed");
        require(myorder.totalContributorsRemain != 0,"Your Order Is Done, And You Sent All of Rewards to Users");
        myorder.totalContributorsRemain = myorder.totalContributorsRemain - (_Index.length);
        
        for (uint i;i < _Index.length ; i++) {
            _balances[address(this)] = _balances[address(this)] - (myorder.tokenPerContributor);
            _balances[orderDataMap[_orderId].contributorAddresses[_Index[i]]] = _balances[orderDataMap[_orderId].contributorAddresses[_Index[i]]] + (myorder.tokenPerContributor);
            userMap[orderDataMap[_orderId].contributorAddresses[_Index[i]]].tokenGainedFromMages+=(myorder.tokenPerContributor);
            orderDataMap[_orderId].isConfirmedByMage[_Index[i]] = true;
        }
        if (myorder.totalContributorsRemain == 0) {
            emit OrderFinished(_orderId);
        }
    }
    
    /// @dev retrieves the value of each the specefic order by `_orderId`
    /// @return the contributors addresses , Time to send that signal by the angel , Status (true , false) of confirmation , Zarela day sent that signal
    function getOrderData(
        uint _orderId
    )
        public
        checkOrderId (_orderId)
        view returns (
            address[] memory,
            uint[]memory,
            bool[]memory,
            uint[] memory)
    {
        return (
            orderDataMap[_orderId].contributorAddresses,
            orderDataMap[_orderId].dataRegistrationTime,
            orderDataMap[_orderId].isConfirmedByMage,
            orderDataMap[_orderId].zarelaDay
            );
    }
    
    /// @dev Receive angels' signals by entering the orderId and just order's owner can access.
    /// @return ipfs hash of signals in this order
    function ownerSpecificData(
        uint _orderId
        )
        public 
        onlyRequester(_orderId)
        checkOrderId(_orderId) 
        view returns
        (
            string[] memory
        )
    {
        return (orderDataMap[_orderId].ipfsHash);
    }
    
    /// @dev Check the orders registered and contributed by the user (angel or mage) who calls the function
    /// @return _ownedOrders and _contributedOrders
    function orderResult()
        public view returns
    (uint[]memory _ownedOrders,
    uint[]memory _contributedOrders)
    {
        return (
            userMap[msg.sender].ownedOrders,
            userMap[msg.sender].contributedOrders
        );
    }
    
    /// @dev Total number of orders registered in Zarela
    /// @return length of all orders that registered in zarela
    function orderSize()
        public view returns (uint){
        return orders.length;
    }
}