import StellarSdk from 'stellar-sdk'
import Stellar from '../stellar/stellar'

/**
 * Adds funds to the given account
 * @param {String} secret - The secret key of the stellar account sending lumens
 * @param {String} amount - The number of lumens to send
 * @param {String} fundPublicKey - The public key of the receiving account
 * @param {String} stellarNetwork - The stellar network
 * @returns {Object} - The transaction result
 */
async function addFundsToAccount(
  secret,
  amount,
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
        asset: StellarSdk.Asset.native(),
        amount,
      })
    )
    .build()

  transaction.sign(userKeyPair)

  await server.submitTransaction(transaction)
}

function init({stellarNetwork}) {
  const form = document.getElementById('fund_form')

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
          fundKey,
          stellarNetwork
        )
        button.disabled = false
        button.textContent = 'Add Lumens'
        Stellar.getStellarBalances(stellarNetwork)
        alert('Funds added successfully')
      } catch (e) {
        button.disabled = false
        button.textContent = 'Add Lumens'
        console.error(e)
        alert('Unable to add funds to account')
      }
    })
  }
}

export default {
  init,
}
