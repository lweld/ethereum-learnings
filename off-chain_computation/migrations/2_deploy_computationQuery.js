var computationQuery = artifacts.require("computationQuery.sol");

module.exports = function(deployer) {
  deployer.deploy(computationQuery);
};