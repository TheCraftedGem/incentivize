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
      const type = balance.asset_type === 'native' ? 'XLM' : balance.asset_code

      newDiv.innerHTML = `${balance.balance}<small>${type}</small>`
      balanceElement.appendChild(newDiv)
    }
  } catch (e) {
    console.error(e)
    if (e.response.title === 'Resource Missing') {
      balanceElement.innerHTML = `<p class="ErrorText">Error: Unable to retrieve balance.<br/>
        Please make sure Stellar account is created and has a minimum balance of 1 XLM.<br/>
        <a href="https://www.stellar.org/account-viewer/#!/" target="_blank" rel="noreferrer">Click here to check</a>.
        </p>`
    } else {
      balanceElement.innerHTML = `<span class="ErrorText">Error: ${
        e.response.title
      }</span>`
    }
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

async function getFundTotal(server, balanceElement) {
  const assetObj = processAsset(self.incentivize.asset)
  let publicKeys = balanceElement.dataset.totalStellarBalances

  publicKeys = publicKeys
    .replace(/\[|\]|"/g, '')
    .split(', ')
    .filter((key) => key.length > 0)

  try {
    if (publicKeys.length > 0) {
      balanceElement.textContent = ''
      const balances = []
      const promises = Array.prototype.map.call(
        publicKeys,
        async(publicKey) => {
          const account = await server.loadAccount(publicKey)

          for (const balance of account.balances) {
            const type =
              balance.asset_type === 'native' ? 'XLM' : balance.asset_code

            if (assetObj.code == type) {
              balances.push(balance.balance)
            }
          }
        }
      )

      await Promise.all(promises)
      const totalBalances = balances.reduce(
        (total, num) => Number(total) + Number(num)
      )
      const newDiv = document.createElement('span')

      newDiv.innerHTML = `${totalBalances}<small>${assetObj.code}</small>`
      balanceElement.appendChild(newDiv)
    } else {
      balanceElement.innerHTML = `0<small>${assetObj.code}</small>`
    }
  } catch (e) {
    console.error(e)
    const newDiv = document.createElement('div')

    newDiv.textContent = `Error: ${e.response.title}`
    balanceElement.appendChild(newDiv)
  }
}

async function getFundTotals(stellarNetwork) {
  const server = createServer(stellarNetwork)
  const fundTotalElements = document.querySelectorAll(
    '[data-total-stellar-balances]'
  )

  if (fundTotalElements) {
    const promises = Array.prototype.map.call(
      fundTotalElements,
      (fundTotalElement) => getFundTotal(server, fundTotalElement)
    )

    await Promise.all(promises)
  }
}

export default {
  getAccountBalances,
  getFundTotals,
  createServer,
  processAsset,
}
