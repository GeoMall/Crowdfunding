pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Crowdfunding.sol";

contract crowdfundingTest
{
    address donatorAddress = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;

    function testIncreaseBalance() public
    {
        Crowdfunding crowdfunding = Crowdfunding(DeployedAddresses.Crowdfunding());

        crowdfunding.setBalance(0);
        crowdfunding.setRequiredAmount(10);
       // msg.value = 20;
        
        uint balance = crowdfunding.increaseBalance(donatorAddress);
        
        uint expectedBalance = 20;
            
        Assert.equal(balance, expectedBalance, "Balance should be increased");
        
    }
}