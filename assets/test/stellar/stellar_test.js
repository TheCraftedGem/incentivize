const expect = require('chai').expect
const Stellar = require('../../js/stellar/stellar')
const StellarSdk = require('stellar-sdk')
const {JSDOM} = require('jsdom')

describe('Stellar', () => {
  describe('createServer', () => {
    it('returns test server when test url given', () => {
      const url = 'https://horizon-testnet.stellar.org/'
      const server = Stellar.default.createServer(url)

      expect(server.serverURL.toString()).to.equal(url)
    })

    it('returns real server when real url given', () => {
      const url = 'https://horizon.stellar.org/'
      const server = Stellar.default.createServer(url)

      expect(server.serverURL.toString()).to.equal(url)
    })
  })
  describe('processAsset', () => {
    it('returns native asset when given XLM', () => {
      let asset = Stellar.default.processAsset({code: 'XLM'})

      expect(asset).to.eql(StellarSdk.Asset.native())

      asset = Stellar.default.processAsset({code: 'XLM', issuer: null})

      expect(asset).to.eql(StellarSdk.Asset.native())

      asset = Stellar.default.processAsset({code: 'XLM', issuer: undefined})

      expect(asset).to.eql(StellarSdk.Asset.native())
    })

    it('returns new asset when given non XLM', () => {
      const asset = Stellar.default.processAsset({
        code: 'TEST',
        issuer: global.StellarPair.publicKey(),
      })

      expect(asset.code).to.eql('TEST')
      expect(asset.issuer).to.eql(global.StellarPair.publicKey())
    })
  })

  describe('getAccountBalances', async() => {
    it('Gets balances for account', async() => {
      const testHTML = `
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
        <p data-stellar-balance="${global.StellarPair.publicKey()}">Loading</p>
      </body>
      </html>
      `
      const jsdom = new JSDOM(testHTML)

      const {window} = jsdom
      const {document} = window

      global.window = window
      global.document = document

      let balance = document.querySelector('[data-stellar-balance]')

      expect(balance.textContent).to.have.string('Loading')

      await Stellar.default.getAccountBalances(
        'https://horizon-testnet.stellar.org'
      )

      balance = document.querySelector('[data-stellar-balance]')

      expect(balance.textContent).to.have.string('XLM')
    })
  })

  describe('getFundTotals', async() => {
    it('sums all balances for a fund', async() => {
      const testHTML = `
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
        <p data-total-stellar-balances="["GCCGLJVIUEC5TVA4SVIIWRYBPXF47MAC2LY6IVLFWDRDER4ZXBFTEGHQ", "GAUKAFQOVKHXUN4TPFK73H7FNDCUJIZN3XCVNQMOFRAGLRF5BN6T6BO3"]">Loading</p>
      </body>
      </html>
      `
      const jsdom = new JSDOM(testHTML)

      const {window} = jsdom
      const {document} = window

      global.window = window
      global.document = document
      self.incentivize = {asset: {code: 'XLM'}}

      let balance = document.querySelector('[data-total-stellar-balances]')

      expect(balance.textContent).to.have.string('Loading')

      await Stellar.default.getFundTotals('https://horizon-testnet.stellar.org')

      balance = document.querySelector('[data-total-stellar-balances]')

      expect(balance.textContent).to.have.string('XLM')
    })
  })
})
