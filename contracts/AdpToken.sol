pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/CappedToken.sol';
import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract AdpToken is CappedToken {
  string public name     = "AdpumpToken";
  string public symbol   = "ADP";
  uint8  public decimals = 18;

  function AdpToken(uint256 _cap) public CappedToken(_cap) {}
}
