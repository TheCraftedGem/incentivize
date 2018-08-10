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
  response = await server.submitTransaction(transaction)

  return response
}

module.exports = {
  create,
  rewardContribution,
}
