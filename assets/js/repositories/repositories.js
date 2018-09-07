function init() {
  const ownerSource = document.querySelector('#repository_owner')
  const nameSource = document.querySelector('#repository_name')

  const ownerSink = document.querySelector('[data-repository-owner]')
  const nameSink = document.querySelector('[data-repository-name]')

  if (ownerSource && ownerSink && nameSource && nameSink) {
    ownerSource.addEventListener('input', () => {
      if (ownerSource.value !== '') {
        ownerSink.textContent = ownerSource.value
      } else {
        ownerSink.textContent = '[owner]'
      }
    })

    nameSource.addEventListener('input', () => {
      if (nameSource.value !== '') {
        nameSink.textContent = nameSource.value
      } else {
        nameSink.textContent = '[name]'
      }
    })
  }
}

export default {
  init,
}
