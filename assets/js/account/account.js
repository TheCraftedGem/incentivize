import StellarSDK from 'stellar-sdk'

function generateStellarAccount() {
  return StellarSDK.Keypair.random()
}

export default {
  generateStellarAccount,
}
