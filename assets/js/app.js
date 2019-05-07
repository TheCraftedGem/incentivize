import Stellar from './stellar/stellar'
import Menu from './menu'
import Alerts from './alerts'
import Loader from './loader'
import {DateTime} from 'luxon'

function showTimesInLocalTimezone() {
  const timestamps = document.querySelectorAll('[data-timestamp]')

  if (timestamps) {
    Array.prototype.forEach.call(timestamps, (timestampElement) => {
      const timestamp = timestampElement.dataset.timestamp
      const datetimeObj = DateTime.fromISO(timestamp, {zone: 'utc'}).toLocal()

      timestampElement.textContent = datetimeObj.toLocaleString(
        DateTime.DATETIME_MED
      )
    })
  }
}

function init(config) {
  Menu.init()
  Alerts.init()
  Loader.init(config)
  showTimesInLocalTimezone()
  Stellar.getAccountBalances(config.stellarNetwork)
  Stellar.getFundTotals(config.stellarNetwork)
}

document.addEventListener('DOMContentLoaded', () => {
  if (self.incentivize) {
    init(self.incentivize)
  }
})

export default {
  init,
}
