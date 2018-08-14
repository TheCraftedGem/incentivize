import 'babel-polyfill'
import 'phoenix_html'
import '../css/app.scss'
import StellarSdk from 'stellar-sdk'

function createServer(network) {
  const server = new StellarSdk.Server(network)

  if (network.includes('test')) {
    StellarSdk.Network.useTestNetwork()
  } else {
    StellarSdk.Network.usePublicNetwork()
  }

  return server
}

function getStellarBalances() {
  const server = createServer(self.incentivize.stellarNetwork)

  const balanceElements = document.querySelectorAll('[data-stellar-balance]')

  if (balanceElements) {
    balanceElements.forEach((balanceElement) => {
      const publicKey = balanceElement.dataset.stellarBalance

      server
        .loadAccount(publicKey)
        .then((account) => {
          for (const balance of account.balances) {
            if (balance.asset_type === 'native') {
              balanceElement.innerHTML = `${balance.balance} Lumens`
            }
          }
        })
        .catch(() => {
          balanceElement.innerHTML = 'Unable to get balance'
        })
    })
  }
}

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

function setupConnectRepositoryHelper() {
  const ownerSource = document.querySelector('#repository_owner')
  const nameSource = document.querySelector('#repository_name')

  const ownerSink = document.querySelector('[data-repository-owner]')
  const nameSink = document.querySelector('[data-repository-name]')

  if (ownerSource && ownerSink && nameSource && nameSink) {
    ownerSource.addEventListener('input', () => {
      if (ownerSource.value !== '') {
        ownerSink.innerHTML = ownerSource.value
      } else {
        ownerSink.innerHTML = '[owner]'
      }
    })

    nameSource.addEventListener('input', () => {
      if (nameSource.value !== '') {
        nameSink.innerHTML = nameSource.value
      } else {
        nameSink.innerHTML = '[name]'
      }
    })
  }
}

function init() {
  setupMenu()
  setupFundForm()
  getStellarBalances()
  setupConnectRepositoryHelper()
}

document.addEventListener('DOMContentLoaded', init)
