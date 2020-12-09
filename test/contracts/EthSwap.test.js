const { assert } = require('chai')

const Token = artifacts.require('Token')
const EthSwap = artifacts.require('EthSwap')

require('chai').use(require('chai-as-promised')).should()

contract('EthSwap', (accounts) => {

    describe('Token deployment', async () => {
        it('contract has a name', async () => {
            const token = await Token.new()
            const name = await token.name()

            assert.equal(name, 'DApp Token')
        })
    })

    describe('EthSwap deployment', async () => {
        it('contract has a name', async () => {
            const ethSwap = await EthSwap.new()
            const name = await ethSwap.name()

            assert.equal(name, 'EthSwap Instant Exchange')
        })

        it('contract has tokens', async () => {
            const token = await Token.new()
            const ethSwap = await EthSwap.new()
            const totalSupply = (await token.totalSupply()).toString();
            await token.transfer(ethSwap.address, totalSupply);
            const balance = await token.balanceOf(ethSwap.address)

            assert.equal(balance.toString(), totalSupply)
        })
    })

})