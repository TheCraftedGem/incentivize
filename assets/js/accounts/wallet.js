import React from 'react'
import ReactDOM from 'react-dom'
import Stellar from '../stellar/stellar'
import Table from 'harmonium/lib/Table'
const TRANSACTION_HISTORY_LIMIT = 100

function getAssetCode(assetCode) {
  if (assetCode) {
    return assetCode
  } else {
    return 'XLM'
  }
}

function formatAmount(amount, sign, assetCode) {
  return `${sign}${amount} ${assetCode}`
}

function handleAccountMerge(publicKey, payment) {
  return {
    amount: '[account merge]',
    accountId: publicKey ? payment.into : payment.account,
  }
}

function handleCreateAccount(payment) {
  const assetCode = getAssetCode(payment.asset_code)

  return {
    amount: formatAmount(payment.starting_balance, '+', assetCode),
    accountId: payment.account,
  }
}

function handlePayment(publicKey, payment) {
  const sign = payment.from === publicKey ? '-' : '+'

  const assetCode = getAssetCode(payment.asset_code)

  return {
    amount: formatAmount(payment.amount, sign, assetCode),
    accountId: payment.from === publicKey ? payment.to : payment.from,
  }
}

function prepareData(publicKey, payment) {
  const data = {
    id: payment.id,
    url: payment._links.self.href,
    type: payment.type,
  }

  if (payment.type === 'account_merge') {
    return Object.assign({}, data, handleAccountMerge(publicKey, payment))
  } else if (payment.type === 'create_account') {
    return Object.assign({}, data, handleCreateAccount(payment))
  } else {
    return Object.assign({}, data, handlePayment(publicKey, payment))
  }
}

async function getTransactionHistory(publicKey, server) {
  const payments = await server
    .payments()
    .forAccount(publicKey)
    .order('desc')
    .limit(TRANSACTION_HISTORY_LIMIT)
    .call()

  const promises = payments.records.map(async(payment) => {
    const transaction = await payment.transaction()

    const data = prepareData(publicKey, payment)

    return Object.assign({}, data, {
      memo: transaction.memo,
      memoType: transaction.memo_type,
    })
  })

  return await Promise.all(promises)
}

function Transactions({transactions}) {
  return (
    <ul class="StackedLinkList">
      {transactions.map((transaction) => (
        <li>
          <a
            href={transaction.url}
            target="_blank"
            rel="nooppener noreferrer"
            class="StackedLinkList-link"
          >
            <div class="rev-Row rev-Row--flex rev-Row--justifySpaceBetween" key={transaction.id}>
              <div class="rev-Col rev-Col--small4 u-truncate" title={transaction.accountId}>
                {transaction.accountId}
              </div>
              <div class="rev-Col rev-Col--small8 Text-right">
                {transaction.amount}
              </div>
              <div class="rev-Col">
                <small>{transaction.memo}</small>
              </div>
            </div>
          </a>
        </li>
      ))}
    </ul>
  )
}

async function buildTransactionHistory(stellarNetwork) {
  const balanceElement = document.querySelector('[data-stellar-balance]')

  if (balanceElement) {
    const transactionHistoryTable = document.querySelector(
      '[data-transaction-history]'
    )

    try {
      const server = Stellar.createServer(stellarNetwork)
      const data = await getTransactionHistory(
        balanceElement.dataset.stellarBalance,
        server
      )

      ReactDOM.render(
        <Transactions transactions={data} />,
        transactionHistoryTable
      )
    } catch (_error) {
      transactionHistoryTable.innerHTML =
        '<span class="ErrorText">Unable to retrieve transaction history</span>'
    }
  }
}

async function init({stellarNetwork}) {
  await buildTransactionHistory(stellarNetwork)

  return null
}

export default {
  init,
}
