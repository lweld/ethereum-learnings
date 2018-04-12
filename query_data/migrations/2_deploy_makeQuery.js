var makeQuery = artifacts.require("makeQuery.sol");

module.exports = function(deployer) {
  deployer.deploy(makeQuery);
};