import StellarSdk from 'stellar-sdk'
import Stellar from '../stellar/stellar'
import Mustache from 'mustache'

/**
 * Adds funds to the given account
 * @param {String} secret - The secret key of the stellar account sending XLM
 * @param {String} amount - The amount to send
 * @param {StellarSdk.Asset} asset - The asset to send
 * @param {String} fundPublicKey - The public key of the receiving account
 * @param {String} stellarNetwork - The stellar network
 * @returns {Object} - The transaction result
 */
async function addFundsToAccount(
  secret,
  amount,
  asset,
  fundPublicKey,
  stellarNetwork
) {
  const server = Stellar.createServer(stellarNetwork)

  const userKeyPair = StellarSdk.Keypair.fromSecret(secret)

  const account = await server.loadAccount(userKeyPair.publicKey())

  const transaction = new StellarSdk.TransactionBuilder(account)
    .addOperation(
      StellarSdk.Operation.payment({
        destination: fundPublicKey,
        asset,
        amount,
      })
    )
    .build()

  transaction.sign(userKeyPair)

  await server.submitTransaction(transaction)
}

function initFundShow({stellarNetwork, asset}) {
  const form = document.getElementById('fund_form')
  const assetObj = Stellar.processAsset(asset)
  const assetCode = assetObj.code

  if (form) {
    form.addEventListener('submit', () => {
      document.querySelector('#fund_form button[type=submit]').disabled = true
    })
  }

  const addLumenForm = document.getElementById('add_lumen_form')

  if (addLumenForm) {
    const amount = document.querySelector('#add_lumen_form #fund_amount')
    const secret = document.querySelector('#add_lumen_form #fund_private_key')
    const button = document.querySelector('#add_lumen_form #fund_add_button')
    const fundKey = document.querySelector('#add_lumen_form #fund_public_key')
      .value

    amount.addEventListener('input', () => {
      button.disabled = amount.value === '' || secret.value === ''
    })

    secret.addEventListener('input', () => {
      button.disabled = amount.value === '' || secret.value === ''
    })

    button.addEventListener('click', async() => {
      button.disabled = true
      button.textContent = 'Funding'
      try {
        await addFundsToAccount(
          secret.value,
          amount.value,
          assetObj,
          fundKey,
          stellarNetwork
        )
        button.disabled = false
        button.textContent = `Add ${assetCode}`
        Stellar.getAccountBalances(stellarNetwork)
        alert('Funds added successfully')
      } catch (e) {
        button.disabled = false
        button.textContent = `Add ${assetCode}`
        console.error(e)
        alert('Unable to add funds to account')
      }
    })
  }
}

function removeRow(index) {
  const row = document.querySelector(`[data-row='${index}']`)

  if (row) {
    row.parentNode.removeChild(row)
  }
}

function setupRemoveRowHandler(index) {
  const removeRowButton = document.querySelector(`[data-delete='${index}']`)

  removeRowButton.addEventListener('click', () => {
    if (document.querySelectorAll('#fund_row_container > div').length > 1) {
      removeRow(index)
    }
  })
}

function addRow(rowLength, template, fundRowContainer) {
  const rendered = Mustache.render(template, {index: rowLength})

  const newDiv = document.createElement('div')

  newDiv.innerHTML = rendered

  fundRowContainer.appendChild(newDiv.firstElementChild)

  setupRemoveRowHandler(rowLength)
}

function initFundForm() {
  const addRowButton = document.querySelector('[data-add-fund-row]')
  const templateElement = document.querySelector('#fund_row_template')
  const fundRowContainer = document.querySelector('#fund_row_container')

  if (addRowButton && templateElement && fundRowContainer) {
    let rowLength = document.querySelectorAll('#fund_row_container > div')
      .length

    for (let i = 0; i < rowLength; i++) {
      setupRemoveRowHandler(i)
    }

    const template = templateElement.innerHTML

    Mustache.parse(template)

    addRowButton.addEventListener('click', () => {
      addRow(rowLength, template, fundRowContainer)
      rowLength = rowLength + 1
    })
  }
}

function init(incentivize) {
  initFundShow(incentivize)
  initFundForm(1)
}

export default {
  init,
}
