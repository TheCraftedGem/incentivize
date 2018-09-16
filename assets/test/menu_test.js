const expect = require('chai').expect
const {JSDOM} = require('jsdom')
const Menu = require('../js/menu')

describe('Menu', () => {
  describe('init', () => {
    it('sets up menu', () => {
      const testHTML = `
      <!DOCTYPE html>
      <html>
      <head>
      </head>
      <body>
      <div className="rev-Drawer rev-Drawer--right">
        <ul class="rev-Menu rev-Menu--horizontalRight">
          <li class="Hide--mediumUp">
            <a class="rev-Drawer-expander"><i class="material-icons">menu</i></a>
          </li>
        </ul>
      </div>
      <div class="rev-Drawer rev-Drawer--right rev-Drawer--fixed Hide--mediumUp">
      <!-- .rev-Drawer--open class needs to be added to .rev-Drawer when the menu is triggered -->
      <a class="rev-Drawer-closer"><i class="material-icons">close</i></a>
      <div class="rev-Drawer-contents">
        <div class="rev-TopBar-item">
          <ul class="rev-Menu">
            <li class="rev-Menu-item">
              <a href="#About">About</a>
            </li>
            <li class="rev-Menu-item">
              <a href="#">Discover</a>
            </li>
            <li class="rev-Menu-item">
              <a href="#Contact">Contact</a>
            </li>
          </ul>
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

      Menu.default.init()

      const expander = document.querySelector('.rev-Drawer-expander')
      const drawer = document.querySelector('.rev-Drawer--fixed')
      const closer = document.querySelector('.rev-Drawer-closer')

      expander.click()
      expect(drawer.classList.contains('rev-Drawer--open')).to.be.true

      closer.click()
      expect(drawer.classList.contains('rev-Drawer--open')).to.be.false
    })
  })
})
