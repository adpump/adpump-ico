pragma solidity ^0.4.16;

interface token {
    function transfer(address receiver, uint amount);
}

/**
 * Adpump presale contract 
 */
contract AdpumpPresale {
	address public beneficiary;
	uint public    fundingGoal;
	uint public    amountRaised;
	uint public    deadline;
	uint public    price;
	token public   tokenReward;
	mapping(address => uint256) public balanceOf;
	bool presaleGoalReached = false;
	bool presaleClosed      = false;

	string public constant symbol = "ADP";

	event GoalReached(address recipient, uint totalAmountRaised);
	event FundTransfer(address backer, uint amount, bool isContribution);

	/**
	 * Constrctor function
	 *
	 * Setup the owner
	 */
	function AdpumpPresale(
		address ifSuccessfulSendTo,
		uint presaleGoalInEthers,
		uint durationInMinutes,
		uint etherCostOfEachToken,
		address addressOfTokenUsedAsReward
	) {
		beneficiary = ifSuccessfulSendTo;
		presaleGoal = presaleGoalInEthers * 1 ether;
		deadline = now + durationInMinutes * 1 minutes;
		price = etherCostOfEachToken * 1 ether;
		tokenReward = token(addressOfTokenUsedAsReward);
	}

	/**
	 * Fallback function
	 *
	 * The function without name is the default function that is called whenever anyone sends funds to a contract
	 */
	function () payable {
		require(!presaleClosed);
		uint amount = msg.value;
		balanceOf[msg.sender] += amount;
		amountRaised += amount;
		tokenReward.transfer(msg.sender, amount / price);
		FundTransfer(msg.sender, amount, true);
	}

  /**
   * Change price 
   */
	function setPrice(uint etherCostOfEachToken) onlyOwner {
		price = etherCostOfEachToken * 1 ether;
	}

	modifier afterDeadline() { if (now >= deadline) _; }

	/**
	 * Check if goal was reached
	 *
	 * Checks if the goal or time limit has been reached and ends the campaign
	 */
	function checkGoalReached() afterDeadline {
		if (amountRaised >= presaleGoal){
			presaleGoalReached = true;
			GoalReached(beneficiary, amountRaised);
		}
		crowdsaleClosed = true;
	}


	/**
	 * Withdraw the funds
	 *
	 * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
	 * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
	 * the amount they contributed.
	 */
	function safeWithdrawal() afterDeadline {
		if (!presaleGoalReached) {
			uint amount = balanceOf[msg.sender];
			balanceOf[msg.sender] = 0;
			if (amount > 0) {
				if (msg.sender.send(amount)) {
					FundTransfer(msg.sender, amount, false);
				} else {
					balanceOf[msg.sender] = amount;
				}
			}
		}

		if (presaleGoalReached && beneficiary == msg.sender) {
			if (beneficiary.send(amountRaised)) {
				FundTransfer(beneficiary, amountRaised, false);
			} else {
				//If we fail to send the funds to beneficiary, unlock funders balance
				presaleGoalReached = false;
			}
		}
	}
}

