import 'babel-polyfill'
import 'phoenix_html'
import '../css/app.scss'
import Stellar from './stellar/stellar'
import Menu from './menu'
import Loader from './loader'

function init(config) {
  Menu.init()
  Loader.init(config)
  Stellar.getAccountBalances(config.stellarNetwork)
}

document.addEventListener('DOMContentLoaded', () => {
  init(self.incentivize)
})
