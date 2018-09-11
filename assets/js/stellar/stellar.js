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

function getStellarBalances(stellarNetwork) {
  const server = createServer(stellarNetwork)
  const assetCode = StellarSdk.Asset.native().code

  const balanceElements = document.querySelectorAll('[data-stellar-balance]')

  if (balanceElements) {
    balanceElements.forEach((balanceElement) => {
      const publicKey = balanceElement.dataset.stellarBalance

      server
        .loadAccount(publicKey)
        .then((account) => {
          for (const balance of account.balances) {
            if (balance.asset_type === 'native') {
              balanceElement.textContent = `${balance.balance} ${assetCode}`
            }
          }
        })
        .catch(() => {
          balanceElement.textContent = 'Unable to get balance'
        })
    })
  }
}

export default {
  getStellarBalances,
  createServer,
}
