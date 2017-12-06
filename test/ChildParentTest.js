let TestChildContract  = artifacts.require('./TestChildContract');
let TestParentContract = artifacts.require('./TestParentContract');

contract('sample', function(accounts){
  it('fails', function(done) {
    let test;
    let test2;
    TestParentContract.new().then(function(instance){
      test_parent = instance;
      return TestChildContract.new();
    }).then(function(instance){
      test_child = instance;
      return test_parent.setChild(test_child.address);
    }).then(function(){
      return test_parent.callSetPrice(10);
    }).then(function(){
      return test_child.price();
    }).then(function(price){
      assert.equal(price.toNumber(), 10);
    }).then(done);
  });
});
