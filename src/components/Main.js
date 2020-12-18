import React, { Component } from 'react'

import BuyForm from './BuyFrom'
import SellForm from './SellForm';


class Main extends Component {

    constructor(props) {
        super(props)

        this.state = { buying: true }

        this.setBuying = this.setBuying.bind(this)
        this.setSelling = this.setSelling.bind(this)
    }

    setBuying(event) {
        event.preventDefault()
        if (!this.state.buying) this.setState({ ...this.state, buying: true })
    }

    setSelling(event) {
        event.preventDefault()
        if (this.state.buying) this.setState({ ...this.state, buying: false })
    }

    render() {
        return (
            <div id="content" className='mt-3'>
                <div className='d-flex justify-content-between mb-3'>
                    <button className='btn btn-light' onClick={this.setBuying}>Buy</button>
                    <span className='text-muted'>&lt; &nbsp; &gt;</span>
                    <button className='btn btn-light' onClick={this.setSelling}>Sell</button>
                </div>
                <div className='card mb-4'>
                    <div className='card-body'>
                        {
                            this.state.buying
                                ? < BuyForm
                                    tokenBalance={this.props.tokenBalance}
                                    ethBalance={this.props.ethBalance}
                                    buyTokens={this.props.buyTokens}
                                />
                                : <SellForm
                                    tokenBalance={this.props.tokenBalance}
                                    ethBalance={this.props.ethBalance}
                                    sellTokens={this.props.sellTokens}
                                />
                        }
                    </div>
                </div>
            </div>
        );
    }
}

export default Main
