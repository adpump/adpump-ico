pragma solidity ^0.4.18;

import './AdpTimelockToken.sol';

contract AdpTeamToken is AdpTimelockToken {

  mapping(address => uint256) released;

  function AdpTeamToken(MintableToken _token, uint256 _releaseTime) public 
    AdpTimelockToken(_token, _releaseTime) 
  {}

  function releaseFrom(address beneficiary) public 
  {
    require(beneficiary != address(0));
    require(now > releaseTime);

    uint256 balance = balanceOf(beneficiary);
    require(balance > 0);

    uint256 releasedTokens = releasedOf(beneficiary);

    uint256 periodMonths = (now - releaseTime) / (3600 * 24 * 30); // month in seconds
    require(periodMonths > 0);

    uint256 canReleasePercents = periodMonths * 8; // 8% each month
    if (periodMonths == 11) { // 11 months later
      canReleasePercents = 90;
    } else if (periodMonths > 12) { // 12 months later
      canReleasePercents = 100;
    }
    uint256 canReleaseTokens = (balance + releasedTokens) * canReleasePercents / 100; // 100%

    require(canReleaseTokens > releasedTokens);

    uint256 amount = canReleaseTokens.sub(releasedTokens);

    require(amount > 0);

    released[beneficiary] = released[beneficiary].add(amount);
    balances[beneficiary] = balances[beneficiary].sub(amount);
    totalSupply = totalSupply.sub(amount);
    token.mint(beneficiary, amount);
  }

  function releasedOf(address _owner) public view returns (uint256 balance) 
  {
    return released[_owner];
  }

}
