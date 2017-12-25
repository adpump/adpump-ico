module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "localhost",
      port: 9545,
      network_id: "*" 
    },
    rinkeby: {
      host: "localhost",
      port: 8545,
      from: "0xE33cb3798E1a57de189dA0Fa8dCD7598cF142eF2",
      network_id: 4
    },
    live: {
      host: "localhost",
      port: 8545,
      from: "0x348Cbf7496Bd549c006FCc3c225a53c8D9667864",
      network_id: 1
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
};

