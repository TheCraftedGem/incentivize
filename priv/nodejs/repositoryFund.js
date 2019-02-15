const StellarSdk = require('stellar-sdk')
const TRANSACTION_TIMEOUT = 30

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
  if (code === StellarSdk.Asset.native().code) {
    return StellarSdk.Asset.native()
  } else {
    return new StellarSdk.Asset(code, issuer)
  }
}

async function generateEscrowAccountXDR(
  network,
  ownerSecret,
  escrowPublicKey,
  startingBalance
) {
  const server = createServer(network)
  const ownerKeyPair = StellarSdk.Keypair.fromSecret(ownerSecret)
  const ownerAccount = await server.loadAccount(ownerKeyPair.publicKey())

  let transaction = new StellarSdk.TransactionBuilder(ownerAccount)
    .addOperation(
      StellarSdk.Operation.createAccount({
        destination: escrowPublicKey,
        startingBalance: startingBalance,
      })
    )
    .setTimeout(TRANSACTION_TIMEOUT)
    .build()

  transaction.sign(ownerKeyPair)

  return transaction.toEnvelope().toXDR('base64')
}

async function setWeightsXDR(
  network,
  escrowSecret,
  supporterPublicKey,
  incentivizePublicKey
) {
  const server = createServer(network)
  const escrowKeyPair = StellarSdk.Keypair.fromSecret(escrowSecret)
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
    .setTimeout(TRANSACTION_TIMEOUT)
    .build()

  transaction.sign(escrowKeyPair)
  return transaction.toEnvelope().toXDR('base64')
}

/**
 * Reward a contribution
 *
 * @param network - The Stellar Network to use
 * @param incentivizeSecret - Incentivize's account secret
 * @param escrowPublicKey - The public key of the escrow account
 * @param contributerPublicKey - The public key of the contributer to incentivize
 * @param amount - The amount to give
 * @param assetInfo - The asset to send
 * @param memoText - A memo about the contribution
 *
 */
async function rewardContributionXDR(
  network,
  incentivizeSecret,
  escrowPublicKey,
  contributerPublicKey,
  amount,
  assetInfo,
  memoText
) {
  const server = createServer(network)
  const escrowAccount = await server.loadAccount(escrowPublicKey)
  const ownerKeyPair = StellarSdk.Keypair.fromSecret(incentivizeSecret)
  const asset = processAsset(assetInfo)

  const memo = StellarSdk.Memo.text(memoText)
  transaction = new StellarSdk.TransactionBuilder(escrowAccount, {memo})
    .addOperation(
      StellarSdk.Operation.payment({
        destination: contributerPublicKey,
        asset: asset,
        amount: amount,
      })
    )
    .setTimeout(TRANSACTION_TIMEOUT)
    .build()

  transaction.sign(ownerKeyPair)

  return transaction.toEnvelope().toXDR('base64')
}

async function addFundsXDR(
  network,
  secret,
  escrowPublicKey,
  amount,
  assetInfo,
  memoText
) {
  const server = createServer(network)
  const ownerKeyPair = StellarSdk.Keypair.fromSecret(secret)
  const ownerAccount = await server.loadAccount(ownerKeyPair.publicKey())
  const asset = processAsset(assetInfo)

  const memo = StellarSdk.Memo.text(memoText)
  transaction = new StellarSdk.TransactionBuilder(ownerAccount, {
    memo,
  })
    .addOperation(
      StellarSdk.Operation.payment({
        destination: escrowPublicKey,
        asset: asset,
        amount: amount,
      })
    )
    .setTimeout(TRANSACTION_TIMEOUT)
    .build()

  transaction.sign(ownerKeyPair)

  return transaction.toEnvelope().toXDR('base64')
}

module.exports = {
  rewardContributionXDR,
  addFundsXDR,
  generateEscrowAccountXDR,
  setWeightsXDR,
}
