module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "localhost",
      port: 9545,
      network_id: "*" 
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
};

