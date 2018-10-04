import Mustache from 'mustache'

function removeRow(index) {
  const row = document.querySelector(`[data-row='${index}']`)

  if (row) {
    row.parentNode.removeChild(row)
  }
}

function setupRemoveRowHandler(index) {
  const removeRowButton = document.querySelector(`[data-delete='${index}']`)

  removeRowButton.addEventListener('click', () => {
    if (document.querySelectorAll('.FundContainer > div').length > 1) {
      removeRow(index)
    }
  })
}

function addRow(rowLength, template, fundRowContainer) {
  const rendered = Mustache.render(template, {index: rowLength})

  const newDiv = document.createElement('div')

  newDiv.innerHTML = rendered

  fundRowContainer.appendChild(newDiv.firstElementChild)

  setupRemoveRowHandler(rowLength)
}

function init() {
  const addRowButton = document.querySelector('[data-add-fund-row]')
  const templateElement = document.querySelector('#fund_row_template')
  const fundRowContainer = document.querySelector('.FundContainer')

  if (addRowButton && templateElement && fundRowContainer) {
    let rowLength = document.querySelectorAll('.FundContainer > div').length

    for (let i = 0; i < rowLength; i++) {
      setupRemoveRowHandler(i)
    }

    const template = templateElement.innerHTML

    Mustache.parse(template)

    addRowButton.addEventListener('click', () => {
      addRow(rowLength, template, fundRowContainer)
      rowLength = rowLength + 1
    })
  }
}

export default {
  init,
}
