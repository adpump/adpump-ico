const AdpCrowdsale = artifacts.require("./AdpCrowdsale.sol")

module.exports = function(deployer, network, accounts) {

  const rate = new web3.BigNumber(2000); // 0.0005 ether per token

  var startTime             = new Date('2017-11-25').getTime() / 1000;
  var endTime               = new Date('2018-12-31').getTime() / 1000;
  var firstStageFinishTime  = new Date('2017-12-25').getTime() / 1000;
  var secondStageFinishTime = new Date('2018-04-01').getTime() / 1000;
  var thirdStageFinishTime  = new Date('2018-07-01').getTime() / 1000;
  var fourthStageFinishTime = new Date('2018-10-01').getTime() / 1000;

  var wallet   = "0x7dFA37CEc204C8FCF95879B060851A06baD9c917";
  var adpump   = "0xd969ab03e351a38a8AD484c8AFE0Bb61cEd6C479";
  var advisors = "0xf2E7223e66fB23580726c0B07aa33EE4789299ff";
  var team     = "0x72fEd1cc066Fd0D0d284EE68084cDC67699c641f";
  var devteam  = team;

  if (network == "rinkeby") {
    firstStageFinishTime  = new Date().getTime() / 1000 + 600;
    secondStageFinishTime = firstStageFinishTime  + 600;
    thirdStageFinishTime  = secondStageFinishTime + 600;
    fourthStageFinishTime = thirdStageFinishTime  + 600;

    wallet   = "0x9B6A5Acbe396dff60bCaE9CbeBe2bdb4080c58BA";
    adpump   = "0x64A3dDC08533e550C81dd13915Bb3549f562eB3A";
    advisors = "0xDE2c5a324EE98C4E3ea96c878672e1FDdCe59eD4";
    team     = "0xA38e3C6e4b55fd8A807E58c58E1493E8a4775963";
    devteam  = "0xDCe4C4Ea1BF83320af4BAcDeeEF1Bf05617d3065";
  } else if (network == "development") {
    startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1 // one second in the future

    firstStageFinishTime = startTime + 1;
    secondStageFinishTime = firstStageFinishTime + 10;
    thirdStageFinishTime = secondStageFinishTime + 10;
    fourthStageFinishTime = thirdStageFinishTime + 10;

    wallet = accounts[0];

    adpump   = accounts[1];
    advisors = accounts[2];
    team     = accounts[3];
    devteam  = accounts[3];
  }

  deployer.deploy(AdpCrowdsale,
    startTime, endTime,
    firstStageFinishTime, secondStageFinishTime,
    thirdStageFinishTime, fourthStageFinishTime,
    adpump, advisors, team, devteam,
    rate, wallet
  );
};
