const { assert } = require('chai')

const Token = artifacts.require('Token')
const EthSwap = artifacts.require('EthSwap')

require('chai').use(require('chai-as-promised')).should()

function tokens(n) {
    return web3.utils.toWei(n, 'ether')
}

contract('EthSwap', ([deployer, investor]) => {

    let token, ethSwap

    before(async () => {
        token = await Token.new()
        ethSwap = await EthSwap.new(token.address)
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

        it('contract has tokens (1,000,000)', async () => {
            const balance = await token.balanceOf(ethSwap.address)

            assert.equal(balance.toString(), totalSupply)
            assert.equal(balance.toString(), tokens('1000000'))
        })
    })

    describe('buyTokens()', async () => {
        let result

        before(async () => {
            // Purchase tokens before each example.
            result = await ethSwap.buyTokens({ from: investor, value: tokens('1') })
        })

        it('allows users to instantly buy tokens for a fixed price', async () => {
            // Check investor token balance after purchase.
            const investorBalance = await token.balanceOf(investor)
            assert.equal(investorBalance.toString(), tokens('100'))

            // Check EthSwap balance after purchase
            let ethSwapBalance = await token.balanceOf(ethSwap.address)
            assert.equal(ethSwapBalance.toString(), tokens('999900'))
            ethSwapBalance = await web3.eth.getBalance(ethSwap.address)
            assert.equal(ethSwapBalance.toString(), tokens('1'))

            // Ensure event TokensPurchased event is properly emitted.
            const event = result.logs[0].args
            assert.equal(event.account, investor)
            assert.equal(event.token, token.address)
            assert.equal(event.amount.toString(), tokens('100').toString())
            assert.equal(event.rate.toString(), '100')
        })
    })

    describe('sellTokens()', async () => {
        let result

        before(async () => {
            // Approve sale of tokens by EthSwap on behalf of user.
            await token.approve(ethSwap.address, tokens('100'), { from: investor })
            // Sell tokens before each example.
            result = await ethSwap.sellTokens(tokens('100'), { from: investor })
        })

        it('allows users to instantly sell tokens to EthSwap for a fixed price', async () => {
            // Check investor token balance after sale.
            const investorBalance = await token.balanceOf(investor)
            assert.equal(investorBalance.toString(), tokens('0'))

            // Check EthSwap balance after sale.
            let ethSwapBalance = await token.balanceOf(ethSwap.address)
            assert.equal(ethSwapBalance.toString(), tokens('1000000'))
            ethSwapBalance = await web3.eth.getBalance(ethSwap.address)
            assert.equal(ethSwapBalance.toString(), tokens('0'))

            // Ensure event TokensSold event is properly emitted.
            const event = result.logs[0].args
            assert.equal(event.account, investor)
            assert.equal(event.token, token.address)
            assert.equal(event.amount.toString(), tokens('100').toString())
            assert.equal(event.rate.toString(), '100')

            // FAILURE: Inventor can't sell more tokens than they have.
            await ethSwap.sellTokens(tokens('500'), { from: investor }).should.be.rejected;
        })
    })

})