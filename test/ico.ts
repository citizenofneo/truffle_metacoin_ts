import { GasERC20Instance } from "../types/truffle-contracts";

const Crowdsale = artifacts.require("Crowdsale");
const GasERC20 = artifacts.require("GasERC20");

contract('Sample tests Crowdsale', (accounts: string[]) => {

  it('should put 3490 Tokens in the first account', async () => {
    const { CrowdsaleInstance, icoToken } = await getIcoAndToken()
    assert.equal(await getTokenBalance(icoToken, CrowdsaleInstance.address), 3490, "3490 wasn't in the Crowdsale");
  });

  it('should buyed 10 Tokens for 4 ETH in the second account', async () => {
    const { CrowdsaleInstance, icoToken } = await getIcoAndToken()
    const buyer1 = accounts[1]
    const buyer2 = accounts[2]

    await CrowdsaleInstance.sendTransaction({ value: 10 * 10 ** 18, from: buyer1 })
    assert.equal(await getTokenBalance(icoToken, buyer1), 24.5, "24.5 wasn't in the Crowdsale")

    await CrowdsaleInstance.sendTransaction({ value: 15 * 10 ** 18, from: buyer2 })
    assert.equal(await getTokenBalance(icoToken, buyer2), 36.75, "36.75 wasn't in the Crowdsale")
  });
});

const getIcoAndToken = async () => {
  const CrowdsaleInstance = await Crowdsale.deployed();
  const icoToken = await GasERC20.at(await CrowdsaleInstance.getTokenAddress())
  return {
    CrowdsaleInstance,
    icoToken
  }
}

const getTokenBalance = async (token: GasERC20Instance, address: string) => Number(await token.balanceOf(address)) / 10 ** Number(await token.decimals())
