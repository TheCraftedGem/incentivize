const {JSDOM} = require('jsdom')
const App = require('../js/app')

describe('App', () => {
  describe('init', () => {
    it('sets up app', () => {
      const testHTML = `
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
      </body>
      </html>
      `
      const jsdom = new JSDOM(testHTML)

      const {window} = jsdom
      const {document} = window

      global.window = window
      global.document = document

      App.default.init({
        stellarNetwork: 'https://horizon-testnet.stellar.org',
        asset: {code: 'XLM', issuer: null},
        jsModuleToLoad: 'Funds',
      })
    })
  })
})
