import Funds from './funds/funds'
import Wallet from './accounts/wallet'

function init(config) {
  if (config && config.jsModuleToLoad) {
    const modules = {
      Funds,
      Wallet,
    }

    modules[config.jsModuleToLoad].init(config)
    return true
  }

  return false
}

export default {
  init,
}
