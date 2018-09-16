import Funds from './funds/funds'

function init(config) {
  if (config && config.jsModuleToLoad) {
    const modules = {
      Funds,
    }

    modules[config.jsModuleToLoad].init(config)
    return true
  }

  return false
}

export default {
  init,
}
