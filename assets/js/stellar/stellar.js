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

function processAsset({code, issuer}) {
  if (code === StellarSdk.Asset.native().code && !issuer) {
    return StellarSdk.Asset.native()
  } else {
    return new StellarSdk.Asset(code, issuer)
  }
}

async function getAccountBalance(server, balanceElement) {
  try {
    const publicKey = balanceElement.dataset.stellarBalance

    balanceElement.textContent = ''
    const account = await server.loadAccount(publicKey)

    for (const balance of account.balances) {
      const newDiv = document.createElement('div')
      const type = balance.asset_type === 'native' ? 'XLM' : balance.asset_type

      newDiv.textContent = `${balance.balance} ${type}`
      balanceElement.appendChild(newDiv)
    }
  } catch (e) {
    balanceElement.textContent = 'Unable to get balance'
  }
}

async function getAccountBalances(stellarNetwork) {
  const server = createServer(stellarNetwork)

  const balanceElements = document.querySelectorAll('[data-stellar-balance]')

  if (balanceElements) {
    const promises = Array.prototype.map.call(
      balanceElements,
      (balanceElement) => getAccountBalance(server, balanceElement)
    )

    await Promise.all(promises)
  }
}

export default {
  getAccountBalances,
  createServer,
  processAsset,
}
