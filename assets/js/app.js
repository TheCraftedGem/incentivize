import Stellar from './stellar/stellar'
import Menu from './menu'
import Alerts from './alerts'
import Loader from './loader'

function init(config) {
  Menu.init()
  Alerts.init()
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
