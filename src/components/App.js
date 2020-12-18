import React, { Component } from 'react'
import Web3 from 'web3'

import Token from '../abis/Token.json'
import EthSwap from '../abis/EthSwap.json'

import Navbar from './Navbar'
import Main from './Main'

import './App.css'

class App extends Component {

    constructor(props) {
        super(props)
        this.state = {
            account: '',
            ethBalance: '0',
            token: {},
            ethSwap: {},
            tokenBalance: '0',
            loading: true
        }
    }

    async componentDidMount() {
        await this.loadWeb3()
        await this.loadBlockchainData()
        this.setState({ ...this.state, loading: false })
    }

    async loadWeb3() {
        if (window.ethereum) {
            window.web3 = new Web3(window.ethereum)
            await window.ethereum.enable()
        } else if (window.web3) {
            window.web3 = new Web3(window.web3.currentProvider)
        } else {
            window.alert('Non-Etherium browser detected. You should consider using MetaMask!')
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3
        const accounts = await web3.eth.getAccounts()
        this.setState({ account: accounts[0] })

        const ethBalance = await web3.eth.getBalance(this.state.account)
        this.setState({ ...this.state, ethBalance })

        // Load Token.
        const networkId = await web3.eth.net.getId()
        const tokenData = Token.networks[networkId]
        if (tokenData) {
            const token = new web3.eth.Contract(Token.abi, tokenData.address)
            this.setState({ ...this.state, token })
            const tokenBalance = await token.methods.balanceOf(this.state.account).call()
            this.setState({ ...this.state, tokenBalance: tokenBalance.toString() })
        } else {
            window.alert('Token contract not deployed to detected network.')
        }

        // Load EthSwap.
        const ethSwapData = EthSwap.networks[networkId]
        if (ethSwapData) {
            const ethSwap = new web3.eth.Contract(EthSwap.abi, ethSwapData.address)
            this.setState({ ...this.state, ethSwap })
        } else {
            window.alert('EthSwap contract not deployed to detected network.')
        }
    }

    buyTokens = (etherAmount) => {
        this.setState({ ...this.state, loading: true })
        this.state.ethSwap.methods.buyTokens()
            .send({ from: this.state.account, value: etherAmount })
            .on('transactionHash', (_) => window.location.reload())
    }

    sellTokens = (tokenAmount) => {
        this.setState({ ...this.state, loading: true })
        this.state.token.methods.approve(this.state.ethSwap.address, tokenAmount)
            .send({ from: this.state.account })
            .on('transactionHash', (_) => {
                this.state.ethSwap.methods.sellTokens(tokenAmount)
                    .send({ from: this.state.account })
                    .on('confirmation', (_) => window.location.reload())
            })
    }

    render() {

        let content

        if (this.state.loading) {
            content = <p id='loader' className='text-center'>Loading...</p>
        } else {
            content = <Main
                tokenBalance={this.state.tokenBalance}
                ethBalance={this.state.ethBalance}
                buyTokens={this.buyTokens}
                sellTokens={this.sellTokens}
            />
        }

        return (
            <div>
                <Navbar account={this.state.account} />
                <div className='container-fluid mt-5'>
                    <div className='row'>
                        <main role='main' className='col-lg-12 ml-auto mr-auto' style={{ maxWidth: '600px' }}>
                            <div className='content mr-auto ml-auto'>
                                {content}
                            </div>
                        </main>
                    </div>
                </div>
            </div>
        )
    }
}

export default App
