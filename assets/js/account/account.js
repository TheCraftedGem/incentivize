import StellarSDK from 'stellar-sdk'

function generateStellarAccount() {
  return StellarSDK.Keypair.random()
}

function setupAccountPage() {
  const secretArea = document.querySelector('[data-private-key-area]')
  const generateStellarButton = document.querySelector(
    '[data-stellar-generate]'
  )

  if (secretArea && generateStellarButton) {
    generateStellarButton.addEventListener('click', () => {
      const keyPair = generateStellarAccount()

      const stellarPublicKeyArea = document.getElementById(
        'user_stellar_public_key'
      )
      const stellarSecretArea = document.querySelector(
        '[data-show-stellar-generated-secret]'
      )

      stellarPublicKeyArea.value = keyPair.publicKey()
      stellarSecretArea.innerHTML = keyPair.secret()

      secretArea.classList.remove('Hide')
      generateStellarButton.classList.add('Hide')
    })
  }
}

export default {
  generateStellarAccount,
  setupAccountPage,
}