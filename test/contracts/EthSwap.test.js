const { assert } = require('chai')

const Token = artifacts.require('Token')
const EthSwap = artifacts.require('EthSwap')

require('chai').use(require('chai-as-promised')).should()

contract('EthSwap', (accounts) => {

    let token, ethSwap

    before(async () => {
        token = await Token.new()
        ethSwap = await EthSwap.new()
        totalSupply = (await token.totalSupply()).toString();
        await token.transfer(ethSwap.address, totalSupply);
    })

    describe('Token deployment', async () => {
        it('contract has a name', async () => {
            const name = await token.name()

            assert.equal(name, 'DApp Token')
        })
    })

    describe('EthSwap deployment', async () => {
        it('contract has a name', async () => {
            const name = await ethSwap.name()

            assert.equal(name, 'EthSwap Instant Exchange')
        })

        it('contract has tokens', async () => {
            const balance = await token.balanceOf(ethSwap.address)

            assert.equal(balance.toString(), totalSupply)
        })
    })

})