import 'babel-polyfill'
import 'phoenix_html'
import '../css/app.scss'

function setupFundForm() {
  const form = document.getElementById('fund_form')

  if (form) {
    form.addEventListener('submit', () => {
      document.querySelector('#fund_form button[type=submit]').disabled = true
    })
  }
}

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
  setupFundForm()
}

document.addEventListener('DOMContentLoaded', init)
