var usingOraclize = artifacts.require("usingOraclize.sol");

module.exports = function(deployer) {
  deployer.deploy(usingOraclize);
};