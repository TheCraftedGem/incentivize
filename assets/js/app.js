import 'babel-polyfill'
import 'phoenix_html'
import '../css/app.scss'
import Account from './account/account'

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

function init() {
  setupMenu()
  Account.setupAccountPage()
}

document.addEventListener('DOMContentLoaded', init)
