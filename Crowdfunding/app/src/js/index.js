// Import libraries
import Web3 from 'web3';

//Import our contract
import crowdfundingArtifact from '../../../build/contracts/Crowdfunding.json';

//test
console.log(crowdfundingArtifact);

const App = 
{
	web3: null,	
	crowdfunding: null,
	account: null,

	start: async function()
	{
		const { Web3 } = this;

		try
		{
			//getting crowdfunding contract instance
			const networkId = await web3.eth.net.getId();
			const deployedCrowdfunding = crowdfundingArtifact.networks[networkId];
			this.crowdfunding = new web3.eth.Contract(
			crowdfundingArtifact.abi,
			deployedCrowdfunding.address,
			);

			//getting accounts
			const accounts = await web3.eth.getAccounts();
			this.account = accounts[0];
			console.log("Company account: " + this.account);

		}
		catch(Error)
		{
			console.error("An error occured while connecting to the contract");
		}	
	},

	increaseBalance: async function()
	{
		try
		{
			const { increaseBalance } = this.crowdfunding.methods;
			var donation = document.getElementById('donation').innerHTML;
			
			//testing
			console.log(this.account);

			const reponse = await increaseBalance().call({from: this.account, value: donation});
			console.log(reponse);
			return reponse;
		}
		catch(error)
		{
			console.error(error);
		}

	},

	setRequiredAmount: async function()
	{
		try
		{
			const { setRequiredAmount } = this.crowdfunding.methods;
			var rAmount = document.getElementById('reqamt').innerHTML;

			//getting accounts
			const accounts = await web3.eth.getAccounts();
			this.account = accounts[0];
			const reponse = await setRequiredAmount(rAmount).call({from: this.account});

		}
		catch(error)
		{
			console.error(error);
		}
	}
};

window.App = App;

window.addEventListener('load', function () {
  
    //window.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8545'))
  
	if(window.ethereum)
	{
		App.web3 = new Web3(window.ethereum);
		window.ethereum.enable();
	}
	else
	{
		App.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8545'));
	}

 	App.start();
});
