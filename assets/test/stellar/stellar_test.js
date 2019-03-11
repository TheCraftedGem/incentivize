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
        issuer: 'GCXSQHLCOHX7M7QYVCYRVNAQ7WYB2UWJDICNDX44NEDX5CH2SXGQTBUQ',
      })

      expect(asset.code).to.eql('TEST')
      expect(asset.issuer).to.eql(
        'GCXSQHLCOHX7M7QYVCYRVNAQ7WYB2UWJDICNDX44NEDX5CH2SXGQTBUQ'
      )
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
        <p data-stellar-balance="GCXSQHLCOHX7M7QYVCYRVNAQ7WYB2UWJDICNDX44NEDX5CH2SXGQTBUQ">Loading</p>
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
})
