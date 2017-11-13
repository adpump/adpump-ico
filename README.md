Installation
============

Install Ethereum TestRPC
------------------------
```bash
sudo pip install eth-testrpc
```

Install Truffle
------------------------
```bash
sudo npm install -g truffle
truffle init
```

Install Submodules
------------------
```bash
git submodule update --init
```

Testing
=======

```bash
truffle install
truffle test
truffle migrate --network testnet --reset
```
