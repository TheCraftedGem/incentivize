const expect = require('chai').expect
const Account = require('../../js/account/account')

describe('Account', () => {
  describe('generateStellarAccount', () => {
    it('return keypair', () => {
      const keypair = Account.default.generateStellarAccount()

      expect(keypair).to.have.property('publicKey')
      expect(keypair).to.have.property('secret')
    })
  })
})
