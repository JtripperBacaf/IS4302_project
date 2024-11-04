const LotteryToken = artifacts.require("LotteryToken");
const LotterySystem = artifacts.require("LotterySystem");

module.exports = async function (deployer) {
  await deployer.deploy(LotteryToken);
  const tokenInstance = await LotteryToken.deployed();

  await deployer.deploy(LotterySystem, tokenInstance.address);
  const lotteryInstance = await LotterySystem.deployed();

};