pragma solidity ^0.4.16;

contract TestChildContract {

  uint public price;

  function TestChildContract() {} 

  function setPrice(uint newPrice) {
    price = newPrice;
  }
}

contract TestParentContract {

  TestChildContract test_child;

  function TestContract() {}

  function setChild(address addr){
    test_child = TestChildContract(addr);
  }

  function callSetPrice(uint b) {
    test_child.setPrice(b);
  }
}
