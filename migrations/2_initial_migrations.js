const PIAIC114977_Token = artifacts.require("PIAIC114977_Token.sol");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(PIAIC114977_Token,1);
};

// transaction hash:    0xba0e8935739f1eaf38cda25a1d6915f47db39855426985e8159428f3d7f11961
// contract address:    0xA8a1860BCbE009E97F3B1d96FBBDCa0C5904846f