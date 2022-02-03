type Network = "development" | "kovan" | "mainnet";

module.exports = (artifacts: Truffle.Artifacts, web3: Web3) => {
  return async (
    deployer: Truffle.Deployer,
    network: Network,
    accounts: string[]
  ) => {
    const SafeMath = artifacts.require("SafeMath");
    // const Ownable = artifacts.require("Ownable");
    // const ConvertLib = artifacts.require("ConvertLib");
    // const MetaCoin = artifacts.require("MetaCoin");

    // await deployer.deploy(ConvertLib);
    // await deployer.link(ConvertLib, MetaCoin);
    // await deployer.deploy(MetaCoin);

    // const metaCoin = await MetaCoin.deployed();
    // console.log(
    //   `Metacoin deployed at ${metaCoin.address} in network: ${network}.`
    // );
  };
};