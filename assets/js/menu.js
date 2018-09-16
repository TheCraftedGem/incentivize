function init() {
  const expander = document.querySelector('.rev-Drawer-expander')
  const drawer = document.querySelector('.rev-Drawer--fixed')
  const closer = document.querySelector('.rev-Drawer-closer')

  if (expander && drawer && closer) {
    expander.addEventListener('click', () => {
      drawer.classList.add('rev-Drawer--open')
    })

    closer.addEventListener('click', () => {
      drawer.classList.remove('rev-Drawer--open')
    })
  }
}

export default {
  init,
}
