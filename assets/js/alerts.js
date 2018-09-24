function init() {
  const alerts = document.querySelectorAll('[data-alert]')

  if (alerts) {
    Array.prototype.map.call(alerts, (alert) => {
      const closer = alert.querySelector('[data-alert-close]')

      closer.addEventListener('click', () => {
        alert.style.display = 'none'
      })
    })
  }
}

export default {
  init,
}
