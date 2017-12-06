const AdpCrowdsale = artifacts.require("./AdpCrowdsale.sol")
//const TutorialTokenCrowdsale = artifacts.require("./TutorialTokenCrowdsale.sol")

module.exports = function(deployer, network, accounts) {
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1 // one second in the future
  const endTime               = new Date(2018, 12, 31).getTime() / 1000;

  //const firstStageFinishTime  = new Date(2017, 12, 25).getTime() / 1000;
  //const secondStageFinishTime = new Date(2018, 04, 01).getTime() / 1000;
  //const thirdStageFinishTime  = new Date(2018, 07, 01).getTime() / 1000;
  //const fourthStageFinishTime = new Date(2018, 10, 01).getTime() / 1000;
  const firstStageFinishTime = startTime + 1;
  const secondStageFinishTime = firstStageFinishTime + 10;
  const thirdStageFinishTime = secondStageFinishTime + 10;
  const fourthStageFinishTime = thirdStageFinishTime + 10;
  //const endTime = fourthStageFinishTime + 10;

  const rate = new web3.BigNumber(2000); // 0.0005 ether per token
  const wallet = accounts[0];

  const adpump   = accounts[1];
  const advisors = accounts[2];
  const team     = accounts[3];

  deployer.deploy(AdpCrowdsale, 
    startTime, endTime, 
    firstStageFinishTime, secondStageFinishTime, 
    thirdStageFinishTime, fourthStageFinishTime,
    adpump, advisors, team,
    rate, wallet
  );
  //deployer.deploy(TutorialTokenCrowdsale, startTime, endTime, rate, wallet);
};
