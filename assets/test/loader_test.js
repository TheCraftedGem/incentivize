const expect = require('chai').expect
const Loader = require('../js/loader')

describe('Loader', () => {
  describe('init', () => {
    it('ignores if config does not exist', () => {
      const isLoaded = Loader.default.init(null)

      expect(isLoaded).to.be.false
    })

    it('loads if config exist', () => {
      const isLoaded = Loader.default.init({
        stellarNetwork: '',
        asset: {code: 'XLM', issuer: null},
        jsModuleToLoad: 'Funds',
      })

      expect(isLoaded).to.be.true
    })
  })
})
