var AdpCrowdsale = artifacts.require("AdpCrowdsale");
var AdpToken         = artifacts.require("AdpToken");
var AdpTimelockToken = artifacts.require("AdpTimelockToken");
var AdpTeamToken     = artifacts.require("AdpTeamToken");

contract('AdpCrowdsale', function(accounts) {
  var crowdsale;
  var crowdsale_addr;
  var token;
  var timelockToken;
  var teamToken;
  var tokensAvailableStage1 = 17546000000000000000000000;
  var tokensAvailableStage2 = 15076000000000000000000000;

  it("check initial tokens supply", function() {

    var bountyVolume = '2.5e+24';
    var advisorsVolume = '2.5e+24';
    var adpumpVolume = '5e+24';
    var teamVolume = '1e+25';

    return AdpCrowdsale.deployed().then(function(instance) {
      crowdsale = instance;
      return crowdsale.tokensAvailable.call();
    }).then(function(balance) {
      assert.equal(balance.toNumber(), tokensAvailableStage1, "Tokens available has to be 17.546m initially")
      return crowdsale.token.call();
    }).then(function(inst) {
      token = AdpToken.at(inst);
      return crowdsale.timelockToken.call();
    }).then(function(inst) {
      timelockToken = AdpTimelockToken.at(inst);
      return crowdsale.teamToken.call();
    }).then(function(inst) {
      teamToken = AdpTeamToken.at(inst);
      return token.balanceOf(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.toString(), bountyVolume, "Bounty volume has to be " + bountyVolume);
      return teamToken.balanceOf(accounts[1]);
    }).then(function(balance) {
      assert.equal(balance.toString(), adpumpVolume, "Adpump should be " + adpumpVolume);
      return teamToken.balanceOf(accounts[2]);
    }).then(function(balance) {
      assert.equal(balance.toString(), advisorsVolume, "Advisors volume should be " + advisorsVolume);
      return teamToken.balanceOf(accounts[3]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), teamVolume, "Team volume should be " + teamVolume);
    });
  });
  it("check tokens buy", function() {
    return crowdsale.currentStage().then(function() {
      return crowdsale.currentStage.call();
    }).then(function(stage) {
      assert.equal(stage, 1, "Stage should be 1");
      return web3.eth.sendTransaction({ gas: 150000, from: accounts[4], to: crowdsale.address, value: web3.toWei(1, 'ether') });
    }).then(function() {
      return timelockToken.balanceOf(accounts[4]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), '2e+21', "Balance after pay 1 ehter should be ");
    });
  });
  it("check tokens release", function(done) {
    setTimeout(function() {
      timelockToken.releaseFrom(accounts[4]).then(function() {
        return token.balanceOf(accounts[4]);
      }).then(function(balance) {
        assert.equal(balance.valueOf(), '2e+21', "Balance after pay 1 ehter should be 2e+21 AdpTimelockToken");
        done();
      });
    }, 2000);
  });
  it("check switch to second stage", function() {
    return crowdsale.nextStage().then(function() {
      return crowdsale.currentStage.call();
    }).then(function(stage) {
      assert.equal(stage, 2, "Stage should be 2");
    });
  });
  it("check tokens buy on second stage", function() {
    return crowdsale.currentStage().then(function() {
      return crowdsale.currentStage.call();
    }).then(function(stage) {
      assert.equal(stage, 2, "Stage should be 2");
      return crowdsale.tokensAvailable.call();
    }).then(function(balance) {
      assert.equal(balance.toNumber(), tokensAvailableStage2, "Tokens available has to be 15.076m on Stage 2")
      return web3.eth.sendTransaction({ gas: 150000, from: accounts[5], to: crowdsale.address, value: web3.toWei(1, 'ether') });
    }).then(function() {
      return token.balanceOf(accounts[5]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), '2e+21', "Balance after pay 1 ehter should be 2e+21 AdpToken");
    });
  });

});

