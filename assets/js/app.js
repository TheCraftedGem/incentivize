import Stellar from './stellar/stellar'
import Menu from './menu'
import Loader from './loader'

function init(config) {
  Menu.init()
  Loader.init(config)
  Stellar.getAccountBalances(config.stellarNetwork)
}

document.addEventListener('DOMContentLoaded', () => {
  if (self.incentivize) {
    init(self.incentivize)
  }
})

export default {
  init,
}
