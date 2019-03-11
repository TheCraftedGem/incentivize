const {JSDOM} = require('jsdom')
const Wallet = require('../../js/accounts/wallet')

describe('Wallet', () => {
  describe('init', () => {
    it('sets up wallet page', () => {
      const testHTML = `
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
        <p data-stellar-balance="GCXSQHLCOHX7M7QYVCYRVNAQ7WYB2UWJDICNDX44NEDX5CH2SXGQTBUQ">Loading</p>
        <div class="rev-TableContainer" data-transaction-history>Loading transaction history</div>
      </body>
      </html>
      `
      const jsdom = new JSDOM(testHTML)

      const {window} = jsdom
      const {document} = window

      global.window = window
      global.document = document

      Wallet.default.init({
        stellarNetwork: 'https://horizon-testnet.stellar.org',
        asset: {code: 'XLM', issuer: null},
        jsModuleToLoad: 'Wallet',
      })
    })
  })
})
