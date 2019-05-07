const StellarSDK = require('stellar-sdk')
const axios = require('axios')

before(async function() {
  this.timeout(30000)

  // Create keypair
  const pair = StellarSDK.Keypair.random()

  // Fund with friendbot to make it an actual account
  await axios.get(`https://friendbot.stellar.org?addr=${pair.publicKey()}`)

  StellarSDK.Network.useTestNetwork()

  global.StellarPair = pair
})
