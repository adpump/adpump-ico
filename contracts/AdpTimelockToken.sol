pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract AdpTimelockToken is MintableToken 
{
  string public name     = "AdpTimelockToken";
  string public symbol   = "ADPTL";
  uint8  public decimals = 18;

  uint256 public releaseTime;

  // AdpToken 
  MintableToken token;

  function AdpTimelockToken(MintableToken _token, uint256 _releaseTime) public 
  {
    require(_releaseTime > now);

    token = _token;
    releaseTime = _releaseTime;
  }

  function release() public 
  {
    releaseFrom(msg.sender);
  }

  function releaseFrom(address beneficiary) public 
  {
    require(beneficiary != address(0));
    require(now > releaseTime);

    uint256 amount = balanceOf(beneficiary);
    require(amount > 0);

    balances[beneficiary] = balances[beneficiary].sub(amount);
    totalSupply       = totalSupply.sub(amount);
    token.mint(beneficiary, amount);
  }
}
