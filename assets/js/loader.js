import FundShow from './funds/show'
import FundNew from './funds/new'
import Wallet from './accounts/wallet'

function init(config) {
  if (config && config.jsModuleToLoad) {
    const modules = {
      FundShow,
      FundNew,
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
