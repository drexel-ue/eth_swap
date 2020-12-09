const Token = artifacts.require('Token');
const EthSwap = artifacts.require('EthSwap');

module.exports = async function (deployer) {
    // Deploy Token.
    await deployer.deploy(Token);
    const token = await Token.deployed();

    // Deploy EthSwap.
    await deployer.deploy(EthSwap);
    const ethSwap = await EthSwap.deployed();

    // Transfer all tokens to EthSwap.
    await token.transfer(ethSwap.address, (await token.totalSupply()).toString());
};

