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
        <div class="rev-Callout success rev-Callout--success" data-alert role="alert">
          <div class="rev-Row rev-Row--flex rev-Row--justifyEnd">
            <div class="rev-Col rev-Col--medium8 Text-center">
              <p></p>
            </div>
            <div class="rev-Col rev-Col--medium2 Text-center">
              <p><i class="material-icons" data-alert-close>close</i></p>
            </div>
          </div>
        </div>
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
        jsModuleToLoad: 'FundShow',
      })
    })
  })
})
