pragma solidity ^0.4.18;

import './AdpToken.sol';
import './AdpTimelockToken.sol';
import './AdpTeamToken.sol';

import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract AdpCrowdsale is Crowdsale, Ownable {

  uint256 firstStageFinishTime;
  uint256 secondStageFinishTime;
  uint256 thirdStageFinishTime;
  uint256 fourthStageFinishTime;

  uint256 public tokensAvailable = 100 * 1000 * 1000 * (10 ** 18);

  uint8 public currentStage = 0;

  AdpTimelockToken public timelockToken;
  AdpTeamToken     public teamToken;

  address adpump;
  address advisors;
  address team;

  function AdpCrowdsale(uint256 _startTime, uint256 _endTime,
    uint256 _firstStageFinishTime, uint256 _secondStageFinishTime,
    uint256 _thirdStageFinishTime, uint256 _fourthStageFinishTime,
    address _adpump, address _advisors, address _team, 
    uint256 _rate, address _wallet) public
    Crowdsale(_startTime, _endTime, _rate, _wallet)
  {
    require(_firstStageFinishTime  > _startTime);
    require(_secondStageFinishTime > _firstStageFinishTime);
    require(_thirdStageFinishTime  > _secondStageFinishTime);
    require(_fourthStageFinishTime > _thirdStageFinishTime);
    require(_endTime               > _fourthStageFinishTime);

    firstStageFinishTime = _firstStageFinishTime;
    secondStageFinishTime = _secondStageFinishTime;
    thirdStageFinishTime = _thirdStageFinishTime;
    fourthStageFinishTime = _fourthStageFinishTime;

    adpump   = _adpump;
    advisors = _advisors;
    team     = _team;

    timelockToken = new AdpTimelockToken(token, firstStageFinishTime);
    teamToken     = new AdpTeamToken(token, firstStageFinishTime);

    teamToken.mint(advisors,       tokensAvailable.div(40)); // 2.5% advisors
    token.mint(address(teamToken), tokensAvailable.div(40)); 
    teamToken.mint(team,           tokensAvailable.div(10)); // 10% team
    token.mint(address(teamToken), tokensAvailable.div(10)); 
    teamToken.mint(adpump,         tokensAvailable.div(20)); // 5% adpump
    token.mint(address(teamToken), tokensAvailable.div(20)); 

    token.mint(wallet,     tokensAvailable.div(40)); // 2.5% bounty

    tokensAvailable = 17546 * 1000 * (10 ** 18); // first stage limit

    currentStage = 1;
  }

  function sendTokens(address beneficiary, uint256 tokens) public onlyOwner
  {
    mintTokens(beneficiary, tokens);
  }

  function mintTokens(address beneficiary, uint256 tokens) internal 
  {
    require(beneficiary != address(0));
    require(tokens > 0);
    require(tokensAvailable >= tokens);

    tokensAvailable = tokensAvailable.sub(tokens);

    if (currentStage == 1) {
      token.mint(address(timelockToken), tokens);
      timelockToken.mint(beneficiary, tokens);
    } else {
      token.mint(beneficiary, tokens);
    }
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    //super.buyTokens(beneficiary);

    uint256 weiAmount = msg.value;

    require(weiAmount >= (10 ** 17)); // 0.1 eth minimum 

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);
    
    // add bonus if currentState is 1
    if (currentStage == 1) {
      if (msg.value >= 501 * (10 ** 18)) {
        tokens = tokens.mul(2); // 50% discount
      } else if (msg.value >= 101 * (10 ** 18)) {
        tokens = tokens.mul(20).div(13); // 35 % discount
      } else if (msg.value >= 30 * (10 ** 18)) {
        tokens = tokens.mul(4).div(3); // 25 % discount
      }
    }

    // update state
    weiRaised = weiRaised.add(weiAmount);

    if (currentStage == 1) {
      token.mint(address(timelockToken), tokens);
      timelockToken.mint(beneficiary, tokens);
    } else {
      token.mint(beneficiary, tokens);
    }
    
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  function nextStage() public onlyOwner 
  {
    uint256 tokensAvailableNew = 0;
    uint8 newStage = currentStage;
    if (currentStage == 1) {
      require(now > firstStageFinishTime);
      tokensAvailableNew = 15076 * 1000 * (10 ** 18); // second stage limit
      newStage = 2;
    } else if (currentStage == 2) {
      require(now > secondStageFinishTime);
      tokensAvailableNew = 16060 * 1000 * (10 ** 18); // third stage limit
      newStage = 3;
    } else if (currentStage == 3) {
      require(now > thirdStageFinishTime);
      tokensAvailableNew = 15514 * 1000 * (10 ** 18); // fourth stage limit
      newStage = 4;
    } else if (currentStage == 4) {
      require(now > fourthStageFinishTime);
      tokensAvailableNew = 15804 * 1000 * (10 ** 18); // fifth stage limit
      newStage = 5;
    } else if (currentStage == 5) {
      require(now > fourthStageFinishTime);
      newStage = 6;
    }
    require(newStage != currentStage);
    currentStage = newStage;
    if (tokensAvailable > 0) {
      token.mint(address(teamToken), tokensAvailable);
      teamToken.mint(adpump, tokensAvailable);
      tokensAvailable = 0;
    }
    tokensAvailable = tokensAvailableNew;
  }

  function createTokenContract() internal returns (MintableToken) 
  {
    return new AdpToken(tokensAvailable);
  }

}
