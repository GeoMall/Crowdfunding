pragma solidity ^0.4.24;

contract Crowdfunding
{
    struct useracc
    {
        uint coins;
        uint donation;
    }
    
    mapping(address => useracc) public useraccount;
    address[] public users;
    
    address company;

    // testing purposes
    event loggingtst(uint num);
    event loggingts(address add);
    
    event contractCreated(string created);
    event balanceIncreased(string newBal);
    event coinsCalculated(string coinCalc);
    event profitsPaid(string paidProfits);
    
    uint public requiredAmmount;
    uint public donation;
    uint public balance;
    uint public coins = 0;
    
    //for each required amount of money donated the users are given coins
    constructor() public payable
    {
        company = msg.sender;
        balance = 0;
        requiredAmmount = 0;
        emit contractCreated("The Contract has been created Successfully");
    }
    
    //setters and getters
    
    //setting required amount for users to donate
    function setRequiredAmount(uint ramount) public
    {
        requiredAmmount = ramount;
    }
    
    //setting user
    function setUser(address _address, uint _coins, uint _donation) public 
    {
        useracc storage user = useraccount[_address];
        
        user.coins = _coins;
        user.donation = _donation;
        
        users.push(_address);
    }
    
    //get all users
    function getUsers() view public returns(address[])
    {
        return users;
    }
    
    //get a particular user 
    function getUser(address _address) view public returns (uint, uint)
    {
        return (useraccount[_address].coins, useraccount[_address].donation);
    }
    
    //returns balace 
    function getBalance() view public returns(uint)
    {
        return balance;
    }

    function setBalance(uint _balance) public
    {
        balance = _balance;
    }
    
    //returns company account balance in wei
    function getCmpBal() view public returns(uint256)
    {
        return company.balance;
    }
    
//--test--\\
    function getCmpAddress() view public returns(address)
    {
        return company;
    }

    //main functionality  
    function increaseBalance() public payable returns (uint)
    {
        //validation
        require(msg.sender != company, "Only the users can attempt to donate");
        require(msg.value >= requiredAmmount, "Donation must be larger than minimumammount");
        
        //setting donation amount and increasing balance
        //donation = msg.value;
        balance += msg.value;
        
        //calculating coins for the user
        coins = msg.value / requiredAmmount;  

        //save the user details
        setUser(msg.sender, coins, msg.value);
        
        //transferring money to company address
        company.transfer(msg.value);
        emit balanceIncreased("Balance increased Successfully");
        return balance;
    }
    
    function payProfits(uint profits) public payable 
    {
        require (msg.sender == company, "Only the company can execute this command");
        require(profits > 0, "Profits must be larger than 0");
        require(profits >= requiredAmmount, "Profits must be larger than 0");
        
        uint coinPool;
        uint _ppcoin = 3;

        //determining the coin pool
        coinPool = (balance / requiredAmmount); 
        
        //calculate pay per coin
       // _ppcoin = (profits / coinPool);
       
       //testing
        emit loggingtst(useraccount[users[0]].coins);  
        emit loggingtst(users.length);
        
        address donatorAdd;
        uint toDonate;
        
        //looping through the users and pay depending on how much coins they have
        for(uint j =0; j < users.length; j++) 
        {
            donatorAdd = users[j];
            toDonate = useraccount[users[j]].coins * _ppcoin;
            emit loggingtst(toDonate);
            donatorAdd.transfer(toDonate);
        }
        
        emit profitsPaid("Successfully transfered profits into customers accounts");
    }


    // default function
    // when you try to call a function that does not exist or call a method with invalid parameters, this is called
    function() public 
    {
        revert("ERROR");
    }
}