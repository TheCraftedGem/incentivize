const expect = require('chai').expect
const Account = require('../../js/account/account')
const {JSDOM} = require('jsdom')

describe('Account', () => {
  describe('generateStellarAccount', () => {
    it('return keypair', () => {
      const keypair = Account.default.generateStellarAccount()

      expect(keypair).to.have.property('publicKey')
      expect(keypair).to.have.property('secret')
    })
  })

  describe('setupAccountPage', () => {
    it('sets up account page', () => {
      const testHTML = `
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
        <input type="text" id="user_stellar_public_key">
        <label class="rev-InputLabel">
        <a data-stellar-generate href="#">
          Don't have a Stellar account? Click here to create one
        </a>
        <div data-private-key-area class="Hide">
          <div data-show-stellar-generated-secret></div>
        </div>
        </label>
      </body>
      </html>
      `
      const jsdom = new JSDOM(testHTML)

      const {window} = jsdom
      const {document} = window

      global.window = window
      global.document = document

      Account.default.setupAccountPage()

      const generateStellarButton = document.querySelector(
        '[data-stellar-generate]'
      )

      generateStellarButton.click()

      const stellarPublicKeyArea = document.getElementById(
        'user_stellar_public_key'
      )

      const stellarSecretArea = document.querySelector(
        '[data-show-stellar-generated-secret]'
      )

      expect(stellarPublicKeyArea.value).to.not.equal('')
      expect(stellarPublicKeyArea.value.startsWith('G')).to.be.true
      expect(stellarSecretArea.innerHTML).to.not.equal('')
      expect(stellarSecretArea.innerHTML.startsWith('S')).to.be.true
    })
  })
})
