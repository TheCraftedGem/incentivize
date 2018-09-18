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

function handleAccountMerge(publicKey, data, payment) {
  return {
    amount: '[account merge]',
    accountId: publicKey ? payment.into : payment.account,
  }
}

function handleCreateAccount(data, payment) {
  const assetCode = getAssetCode(payment.asset_code)

  return {
    amount: formatAmount(payment.starting_balance, '+', assetCode),
    accountId: payment.funder,
  }
}

function handlePayment(publicKey, data, payment) {
  const sign = payment.from === publicKey ? '-' : '+'

  const assetCode = getAssetCode(payment.asset_code)

  data.amount = formatAmount(payment.amount, sign, assetCode)

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
    return Object.assign({}, data, handleAccountMerge(publicKey, data, payment))
  } else if (payment.type === 'create_account') {
    return Object.assign({}, data, handleCreateAccount(data, payment))
  } else {
    return Object.assign({}, data, handlePayment(publicKey, data, payment))
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
    <Table striped>
      <Table.Head>
        <Table.Row>
          <Table.Header>Account ID</Table.Header>
          <Table.Header>Amount</Table.Header>
          <Table.Header>Memo</Table.Header>
          <Table.Header>Operation</Table.Header>
        </Table.Row>
      </Table.Head>
      <Table.Body>
        {transactions.map((transaction) => (
          <Table.Row key={transaction.id}>
            <Table.Data>{transaction.accountId}</Table.Data>
            <Table.Data>{transaction.amount}</Table.Data>
            <Table.Data>{transaction.memo}</Table.Data>
            <Table.Data>
              <a
                href={transaction.url}
                target="_blank"
                rel="nooppener noreferrer"
              >
                {transaction.id}
              </a>
            </Table.Data>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  )
}

async function buildTransactionHistory(stellarNetwork) {
  const balanceElement = document.querySelector('[data-stellar-balance]')

  if (balanceElement) {
    const server = Stellar.createServer(stellarNetwork)
    const data = await getTransactionHistory(
      balanceElement.dataset.stellarBalance,
      server
    )

    ReactDOM.render(
      <Transactions transactions={data} />,
      document.querySelector('[data-transaction-history]')
    )
  }
}

async function init({stellarNetwork}) {
  await buildTransactionHistory(stellarNetwork)

  return null
}

export default {
  init,
}
