import React from 'react'
import ReactDOM from 'react-dom'
import Stellar from '../stellar/stellar'
const transactionHistoryLimit = 100

function prepareData(publicKey, payment) {
  const data = {
    type: payment.type,
  }

  if (payment.type === 'account_merge') {
    data.amount = '[account merge]'
    data.accountId =
      payment.account === publicKey ? payment.into : payment.account
  } else if (payment.type === 'create_account') {
    data.amount = `+${ payment.starting_balance}`
    data.accountId = payment.funder
    if (payment.asset_code) {
      data.asset_code = payment.asset_code
    } else {
      data.asset_code = 'XLM'
    }
  } else {
    data.accountId = payment.from === publicKey ? payment.to : payment.from

    const sign = payment.from === publicKey ? '-' : '+'

    data.amount = `${sign}${payment.amount}`

    if (payment.asset_code) {
      data.asset_code = payment.asset_code
    } else {
      data.asset_code = 'XLM'
    }
  }

  return data
}

async function getTransactionHistory(publicKey, server) {
  const payments = await server
    .payments()
    .forAccount(publicKey)
    .order('desc')
    .limit(transactionHistoryLimit)
    .call()

  const promises = payments.records.map(async(payment) => {
    const transaction = await payment.transaction()

    const data = prepareData(publicKey, payment)

    return Object.assign({}, data, {
      transactionID: transaction.id,
      transactionURL: payment._links.transaction.href,
      memo: transaction.memo,
      memoType: transaction.memo_type,
    })
  })

  return await Promise.all(promises)
}

async function buildTransactionHistory(stellarNetwork) {
  const balanceElement = document.querySelector('[data-stellar-balance]')

  if (balanceElement) {
    const server = Stellar.createServer(stellarNetwork)
    const data = await getTransactionHistory(
      balanceElement.dataset.stellarBalance,
      server
    )

    const Transactions = ({transactions}) => {
      return (
        <table>
          <thead>
            <tr>
              <th>Account ID</th>
              <th>Amount</th>
              <th>Memo</th>
              <th>TransactionID</th>
            </tr>
          </thead>
          <tbody>
            {transactions.map((transaction) => (
              <tr key={transaction.transactionID}>
                <td>{transaction.accountId}</td>
                <td>{transaction.amount} {transaction.asset_code}</td>
                <td>{transaction.memo}</td>
                <td>
                  <a href={transaction.transactionURL}>
                    {transaction.transactionID}
                  </a>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )
    }

    ReactDOM.render(
      <Transactions transactions={data} />,
      document.querySelector('[data-transaction-history]')
    )

    console.log(data)
  }
}

async function init({stellarNetwork}) {
  await buildTransactionHistory(stellarNetwork)

  return null
}

export default {
  init,
}
