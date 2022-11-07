const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");
const compiledUserPermission = require("./build/UserPermission.json");
 
const provider = new HDWalletProvider(
  'tooth rescue frown bicycle road during cup story spoil engage obey area',
  "https://goerli.infura.io/v3/eaf9617414c34ae38b29b7bf31c0ba30"
);
const web3 = new Web3(provider);
 
const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
 
  console.log("Attempting to deploy from account", accounts[0]);
 
  const result = await new web3.eth.Contract(compiledUserPermission.abi)
    .deploy({ data: compiledUserPermission.evm.bytecode.object })
    .send({ gas: "1400000", from: accounts[0] });
 
  console.log("Contract deployed to", result.options.address);
  provider.engine.stop();
};
deploy();