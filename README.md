# Incentivize

[![Coverage Status](https://coveralls.io/repos/github/revelrylabs/incentivize/badge.svg?branch=master)](https://coveralls.io/github/revelrylabs/incentivize?branch=master)
[![Build Status](https://travis-ci.com/revelrylabs/incentivize.svg?token=eDnMwv6sT4GHB9E2RzXt&branch=master)](https://travis-ci.com/revelrylabs/incentivize)

Product Owner: Gerard Ramos

- **Project Start Date:** 7-30-18
- **Product Launch Date:** 8-15-18

## Links to relevant docs, repos, etc.

| Thing                  | Location                                                                                                |
| ---------------------- | ------------------------------------------------------------------------------------------------------- |
| Waffle Board           | [waffle.io](https://waffle.io/revelrylabs/incentivize)                                                  |
| Google Drive           | [Project Folder](https://drive.google.com/drive/u/0/folders/1lY2hz6KTeVWQ82HzeTiPBVui6xm3RISs)          |
| Sprint Reports         | [Sprint Report Folder](https://drive.google.com/drive/u/0/folders/1vb3BtxN6XlaU38Z-bfh6xluqRG5LRoc2)    |
| Continuous Integration | [Travis-CI](https://travis-ci.com/revelrylabs/incentivize)                                              |
| Style Guide            | [TBD]()                                                                                                 |
| Staging                | [https://incentivize-staging.prod.revelry.net/](https://incentivize-staging.prod.revelry.net/) |
| Production             | [incentivize.io](https://incentivize.io)                                                           |

## Compatibility Targets

This is currently for Web Only and we will support our standard compatibility targets.

### Web App Browser Compatibility Targets

| OS      | Browsers                                                 |
| ------- | -------------------------------------------------------- |
| Windows | IE 11+, Chrome (latest), Firefox (latest), Edge (latest) |
| Mac     | Chrome (latest), Firefox (latest), Safari (latest)       |
| iOS     | Safari (latest)                                          |
| Android | Chrome (latest)                                          |

## The Project Brief

### The Idea

Incentivize is a platform that allows companies, repository owners, or interested parties to reward people for their contributions to open source projects, thus incentivising more contributors to work on those projects.

### Who are we building for?

1.  The first are supporters who want to invest in getting more people contributing to open source projects they have interest in by depositing cryptocurrency([Lumens](https://www.stellar.org/lumens/) for MVP) for different actions completed in GitHub.
2.  The second are the contributors themselves who will receive the Lumens as reward for their contributions to open source projects.

### What is the main problem we are trying to solve?

It can be difficult to maintain and grow Open Source projects. Contributors often don't get rewarded for open source work so there is a lack of incentives to make meaningful contributions.

### What is the core loop?

[Business Process Model files](https://drive.google.com/drive/u/0/folders/1rvOIewNT--5AdBFv4aQESouD-WH4Pm4N)

**Repo Admins:** A user with repository admin privleges logs in via GitHub and authorizes the incentivize webhook so that it is available to be incentivized inside of the application.

**Supporters:** A user logs in and is able to add cryptocurrency to be distributed to any projects bank that will then be allocated to users who contribute to that project.

**Contributors:** A user logs in and finds interesting projects to contribute to. They are then rewarded cryptocurrency based on their contributions.

## Nouns & Verbs

### Nouns

**Contributors:** the people who work on open source projects and are in turn rewarded with Lumens from the Project Fund. Contributor's can be anyone who contributes to a GitHub project. From opening issues, making comments, opening or reviewing pull requests. Any person who complete's an action on the open source GitHub Project is contributing.

**Supporters:** the people who choose projects to support by adding lumens to the project fund. Supporters are anyone who is motivated to support a project by backing it with Lumens. It could be the owner of the repository, a business, or just a single person who uses this open source tool and wants to motivate others to improve it.

**Lumens:** Stellar's cryptocurrency (XLM) that will be used to incentvize projects and reward contributors.

**Stellar:** Stellar is a platform that connects reward systems and people using secure transactions.

**Projects:** Open Source GitHub repositories that allow for incentivize connection through a GitHub Webhook

**Webhook:** A simple event-notification via HTTP POST. What will allow incentivize to read data from repositories so that contributors can be rewarded with Lumens.

**Stellar Accounts:** required accounts to send and receive Lumens. Upon creation a public and secret key are created.

**Public Key:** How stellars are transferred between people. Think Venmo username or PayPal email.

**Secret Key:** How one accesses their Stellar Account. Only generated and displayed once. A user must place their Secret Key somewhere safe and must have it to access their stellar account.

**Project Fund:** Where a supporter's Lumens are held and rewarded to contributors based on GitHub actions. There can be many Project Funds per project. A Project Fund has one supporter and many contributors. A supporter can have many Project Funds.

### Verbs

**Connect GitHub:** Connect GitHub accounts to log into incentivize

**Support:** add Lumen's to a project fund on a project.

**Contribute:** take GitHub actions on an incentivized project to earn rewards

## Team

| Role             | Person          |
| ---------------- | --------------- |
| Client           | Revelry         |
| Product Owner    | Gerard Ramos    |
| PM               | Colin Scott     |
| Tech Lead        | Bryan Joseph    |
| Engineer         | Joel Wietelmann |
| Designer         | Brittany Gay    |
| QA               | TBD             |
| Business Analyst | TBD             |
| Account Manager  | TBD             |

## Project Setup

Project can be set up by running `sh ./bin/setup`. It does the steps defined below.
Note that Elixir 1.5 or greater is required in order to start it.

Once run, follow directions and start app by running `sh ./bin/server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Local Webhooks

Run `sh ./bin/tunnel` and you'll see something like this:

```
Forwarding HTTP traffic from https://incentivize-joels-mbp-joel.serveo.net
Press g to start a GUI session and ctrl-c to quit.
Starting GUI...Finished
```

This tunnels public traffic from `https://incentivize-<your hostname>-<your user>.serveo.net` to `http://localhost:4000` so that GitHub can trigger your webhooks.

# Tech Stack

- Elixir
- Phoenix Web Framework

#### Explanation

The Phoenix app will manage all things, including GitHub web hooks. Node will be used to process stellar transactions via StellarSDK js client.

### Requirements

- Elixir (Language)
- Phoenix (Web framework)
- node.js (Used to process stellar transactions)
- StellarSDK (JavaScript Stellar Client)

- GitHub OAuth App (Required to sign in, view user's organizations)
- GitHub App (Required for connecting repositories)

#### Creating an OAuth App

Here we are using the localhost url, `http://localhost:4000`, In production use your prod URL

- Go to https://github.com/settings/developers
- Click `New OAuth App`
- Put in the following:
  - Application Name: <Your App Name>
  - Homepage URL: http://localhost:4000
  - Authorization callback URL: http://localhost:4000/auth/github/callback
- Click `Update application`

- On the page that shows up, put value from `Client ID` and `Client Secret` into the
  config below for `Incentivize.Github.OAuth`

```elixir
# Configuration for GitHub OAuth
config :incentivize, Incentivize.Github.OAuth,
  client_id: <github_app_client_id>, #Client ID from this page
  client_secret: <github_app_client_secret> #Client secret from this page
```

#### Creating a GitHub App

Since you will be receiving webhooks, you will need to use a domain other than `localhost`. You can use the script at `bin/tunnel` to create a domain to use. This will let you use the webhooks locally

- Go to https://github.com/settings/developers
- Click `New OAuth App`
- Put in the following:
  - GitHub App name: <Your App Name>
  - Homepage URL: https://<my_domain>
  - User authorization callback URL: https://<my_domain>/auth/github/callback
  - Setup URL (optional): https://<my_domain>/repos/settings
  - Webhook URL: https://<my_domain>/github/webhooks
  - Webhook Secret: `<random secret>`
  - Permissions:
    - Issues: Read-only
    - Pull requests: Read-only
  - Subscribe to Events
    - Issue comment
    - Issues
    - Pull request
- Click `Create GitHub App`

Now go into your newly created Github App. Generate a private key by clicking `Generate a private key`.

- From this page, add the following to the `Incentivize.Github.App` portion of your app configuration

```elixir
# Configuration for GitHub App
config :incentivize, Incentivize.Github.App,
  app_id: <github_app_id>, #Should be found in `About` section of page
  private_key: <github_app_private_key>, #contents of private key .pem file as a string
  webhook_secret: <github_app_webhook_secret> #the webhook secret you created for the app
  app_slug: <github_app_slug> # https://github.com/settings/apps/:app_slug
```

### Getting a Stellar Account on Testnet

For development, you will need a Stellar Account on the Testnet

- Go to https://www.stellar.org/laboratory/#account-creator?network=test
- Click `Generate Keypair`
- Take not of the Public Key and Secret Key
- To let Friendbot fund your account with lumens, put your Public Key into the box on the bottom of the page and click `Get test network lumens`
- Add your Public Key and Secret Key to your app configuration

```elixir
config :incentivize, Incentivize.Stellar,
  network_url: "https://horizon-testnet.stellar.org",
  public_key: <stellar_public_key>,
  secret: <stellar_secret_key>
```

### Required Secrets

In development, values can go into `config/dev.secret.exs`.

```elixir
# Configuration for GitHub OAuth
config :incentivize, Incentivize.Github.OAuth,
  client_id: <github_app_client_id>,
  client_secret: <github_app_client_secret>

# Configuration for GitHub App
config :incentivize, Incentivize.Github.App,
  app_id: <github_app_id>,
  private_key: <github_app_private_key>, #contents of .pem file as a string
  webhook_secret: <github_app_webhook_secret> #webhook secret of GitHub app
  app_slug: <github_app_slug> # https://github.com/settings/apps/:app_slug

config :incentivize, Incentivize.Stellar,
  network_url: <stellar_network_url>, # Optional. Defaults to test network.
  public_key: <stellar_public_key>,
  secret: <stellar_secret>
```

### Production

There is a Dockerfile for production deployments. The Dockerfile builds a release and runs the app using that. `rel/config/prod_runtime_config.exs` contains the production configuration that looks for environment variables at runtime.
