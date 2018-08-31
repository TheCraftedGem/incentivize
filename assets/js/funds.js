import Mustache from 'mustache'

function addRow(template, fundRowContainer) {
  const index = document.querySelectorAll('#fund_row_container > div').length

  const rendered = Mustache.render(template, {index})

  fundRowContainer.innerHTML += rendered
}

function init() {
  const addRowButton = document.querySelector('[data-add-fund-row]')
  const templateElement = document.querySelector('#fund_row_template')
  const fundRowContainer = document.querySelector('#fund_row_container')

  if (addRowButton && templateElement && fundRowContainer) {
    const template = templateElement.innerHTML

    Mustache.parse(template)

    addRowButton.addEventListener('click', () => {
      addRow(template, fundRowContainer)
    })
  }
}

export default {
  init,
}
