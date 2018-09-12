const expect = require('chai').expect
const Stellar = require('../../js/stellar/stellar')
const StellarSdk = require('stellar-sdk')

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
        issuer: 'GAQHB7ZBZ3CUKD5GCO4XVY67GQ3LMFK4MCJUJZCZJYGIHJOMUFHXV7VT',
      })

      expect(asset.code).to.eql('TEST')
      expect(asset.issuer).to.eql(
        'GAQHB7ZBZ3CUKD5GCO4XVY67GQ3LMFK4MCJUJZCZJYGIHJOMUFHXV7VT'
      )
    })
  })
})
