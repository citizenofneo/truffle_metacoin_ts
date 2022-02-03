type Network = "development" | "kovan" | "mainnet";

module.exports = (artifacts: Truffle.Artifacts, web3: Web3) => {
  return async (
    deployer: Truffle.Deployer,
    network: Network,
    accounts: string[]
  ) => {
    const SafeMath = artifacts.require("SafeMath");
    const Crowdsale = artifacts.require("Crowdsale");
    const GasERC20 = artifacts.require("GasERC20");
   
    await deployer.deploy(SafeMath);
    await deployer.link(SafeMath, [GasERC20, Crowdsale])

    await deployer.deploy(GasERC20);
    await deployer.link(GasERC20, Crowdsale)

    await deployer.deploy(Crowdsale);
    console.log(
      `Crowdsale deployed at ${Crowdsale.address} in network: ${network}.`
    );
  };
};