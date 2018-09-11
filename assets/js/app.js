import 'babel-polyfill'
import 'phoenix_html'
import '../css/app.scss'
import Funds from './funds/funds'
import Repositories from './repositories/repositories'
import Stellar from './stellar/stellar'

function setupMenu() {
  const expander = document.querySelector('.rev-Drawer-expander')
  const drawer = document.querySelector('.rev-Drawer--fixed')
  const closer = document.querySelector('.rev-Drawer-closer')

  if (expander && drawer && closer) {
    expander.addEventListener('click', () => {
      drawer.classList.add('rev-Drawer--open')
    })

    closer.addEventListener('click', () => {
      drawer.classList.remove('rev-Drawer--open')
    })
  }
}

function init(config) {
  setupMenu()
  Stellar.getXLMBalances(config.stellarNetwork)

  if (config && config.jsModuleToLoad) {
    const modules = {
      Funds,
      Repositories,
    }

    modules[config.jsModuleToLoad].init(config)
  }
}

document.addEventListener('DOMContentLoaded', () => {
  init(self.incentivize)
})
