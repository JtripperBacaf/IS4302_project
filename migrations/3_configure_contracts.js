module.exports = async function (deployer, network, accounts) {
    const lotteryInstance = await artifacts.require("LotterySystem").deployed();
  
    // Set the charity address, adjust percentages, etc.
    await lotteryInstance.setCharityAddress("0xCharityAddress", { from: accounts[0] });
  };