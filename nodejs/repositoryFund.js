const StellarSdk = require('stellar-sdk')

function createServer(network) {
  const server = new StellarSdk.Server(network)

  if (network.includes('test')) {
    StellarSdk.Network.useTestNetwork()
  } else {
    StellarSdk.Network.usePublicNetwork()
  }

  return server
}

/**
 * Generates a random keypair to be
 * used to create new Stellar Account
 */
function generateRandomKeyPair() {
  keypair = StellarSdk.Keypair.random()

  return {
    publicKey: keypair.publicKey(),
    secret: keypair.secret(),
  }
}

async function generateEscrowAccount(server, ownerKeyPair) {
  const ownerAccount = await server.loadAccount(ownerKeyPair.publicKey())

  const escrowKey = StellarSdk.Keypair.random()
  let transaction = new StellarSdk.TransactionBuilder(ownerAccount)
    .addOperation(
      StellarSdk.Operation.createAccount({
        destination: escrowKey.publicKey(),
        startingBalance: '2.5000000',
      })
    )
    .build()

  transaction.sign(ownerKeyPair)

  let response = await server.submitTransaction(transaction)

  return {
    keyPair: escrowKey,
    transactionResponse: response,
  }
}

async function setWeights(
  server,
  escrowKeyPair,
  supporterPublicKey,
  incentivizePublicKey
) {
  const escrowAccount = await server.loadAccount(escrowKeyPair.publicKey())

  const transaction = new StellarSdk.TransactionBuilder(escrowAccount)
    .addOperation(
      StellarSdk.Operation.setOptions({
        signer: {
          ed25519PublicKey: supporterPublicKey,
          weight: 1,
        },
      })
    )
    .addOperation(
      StellarSdk.Operation.setOptions({
        masterWeight: 0,
        lowThreshold: 1,
        medThreshold: 1,
        highThreshold: 2,
        signer: {
          ed25519PublicKey: incentivizePublicKey,
          weight: 2,
        },
      })
    )
    .build()

  transaction.sign(escrowKeyPair)
  response = await server.submitTransaction(transaction)

  return response
}

/**
 * Creates Repository Fund
 *
 * @param network - The Stellar Network to use
 * @param incentivizeSecret - Incentivize's account secret
 * @param supporterPublicKey - The public key of the Supporter who will fund the account
 */
async function create(network, incentivizeSecret, supporterPublicKey) {
  const server = createServer(network)

  const incentivizeKey = StellarSdk.Keypair.fromSecret(incentivizeSecret)

  const escrowResult = await generateEscrowAccount(server, incentivizeKey)
  const escrowKeyPair = escrowResult.keyPair

  await setWeights(
    server,
    escrowKeyPair,
    supporterPublicKey,
    incentivizeKey.publicKey()
  )

  return escrowKeyPair.publicKey()
}

/**
 * Reward a contribution
 *
 * @param network - The Stellar Network to use
 * @param incentivizeSecret - Incentivize's account secret
 * @param escrowPublicKey - The public key of the escrow account
 * @param contributerPublicKey - The public key of the contributer to incentivize
 * @param amount - The amount of XLM to give
 * @param memoText - A memo about the contribution
 *
 */
async function rewardContribution(
  network,
  incentivizeSecret,
  escrowPublicKey,
  contributerPublicKey,
  amount,
  memoText
) {
  const server = createServer(network)
  const escrowAccount = await server.loadAccount(escrowPublicKey)
  const ownerKeyPair = StellarSdk.Keypair.fromSecret(incentivizeSecret)

  memo = StellarSdk.Memo.text(memoText)
  transaction = new StellarSdk.TransactionBuilder(escrowAccount, {memo})
    .addOperation(
      StellarSdk.Operation.payment({
        destination: contributerPublicKey,
        asset: StellarSdk.Asset.native(),
        amount: amount,
      })
    )
    .build()

  transaction.sign(ownerKeyPair)
  transactionResult = await server.submitTransaction(transaction)

  return transactionResult._links.transaction.href
}

async function addFunds(network, secret, escrowPublicKey, amount, memoText) {
  const server = createServer(network)
  const ownerKeyPair = StellarSdk.Keypair.fromSecret(secret)
  const ownerAccount = await server.loadAccount(ownerKeyPair.publicKey())

  memo = StellarSdk.Memo.text(memoText)
  transaction = new StellarSdk.TransactionBuilder(ownerAccount, {
    memo,
  })
    .addOperation(
      StellarSdk.Operation.payment({
        destination: escrowPublicKey,
        asset: StellarSdk.Asset.native(),
        amount: amount,
      })
    )
    .build()

  transaction.sign(ownerKeyPair)
  transactionResult = await server.submitTransaction(transaction)

  return transactionResult._links.transaction.href
}

module.exports = {
  create,
  rewardContribution,
  generateRandomKeyPair,
  addFunds,
}
