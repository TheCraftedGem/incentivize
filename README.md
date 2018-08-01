|            | Build Status                                                                                                                                                 |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Staging    | [![Build Status](https://travis-ci.com/revelrylabs/incentivize.svg?token=eDnMwv6sT4GHB9E2RzXt&branch=master)](https://travis-ci.com/revelrylabs/incentivize) |
| Production | [![Build Status](https://travis-ci.com/revelrylabs/incentivize.svg?token=eDnMwv6sT4GHB9E2RzXt&branch=master)](https://travis-ci.com/revelrylabs/incentivize) |

# Incentivize

Product Owner: Gerard Ramos

- **Project Start Date:** 7-30-18
- **Product Launch Date:** 8-15-18

## Links to relevant docs, repos, etc.

| Thing                  | Location                                                                                             |
| ---------------------- | ---------------------------------------------------------------------------------------------------- |
| Waffle Board           | [waffle.io](https://waffle.io/revelrylabs/incentivize)                                               |
| Google Drive           | [Project Folder](https://drive.google.com/drive/u/0/folders/1lY2hz6KTeVWQ82HzeTiPBVui6xm3RISs)       |
| Sprint Reports         | [Sprint Report Folder](https://drive.google.com/drive/u/0/folders/1vb3BtxN6XlaU38Z-bfh6xluqRG5LRoc2) |
| Continuous Integration | [Travis-CI](https://travis-ci.com/revelrylabs/incentivize)                                           |
| Style Guide            | [TBD]()                                                                                              |
| Staging                | [incentivize.stage.revelry.net](https://incentivize.stage.revelry.net/)                              |
| Production             | [incentivize.io](https://incentivize.io)                                                             |

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

**Repo Admins:** A user with repository admin privleges logs in via GitHub and authorizes the incentivize webhook so that it is available to be incentivized inside of the application.

**Supporters:** A user logs in and is able to add cryptocurrency to be distributed to any projects bank that will then be allocated to users who contribute to that project.

**Contributors:** A user logs in and finds interesting projects to contribute to. They are then rewarded cryptocurrency based on their contributions.

## Nouns & Verbs

### Nouns
**Contributors:** the people who work on open source projects and are in turn rewarded with Lumens from the Project Fund. Contributor's can be anyone who contributes to a GitHub project. From opening issues, making comments, opening  or reviewing pull requests. Any person who complete's an action on the open source GitHub Project is contributing. 

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

| Role             | Person          | Email               |
| ---------------- | --------------- | ------------------- |
| Client           | Revelry         | gerard@revelry.co   |
| Product Owner    | Gerard Ramos    | gerard@revelry.co   |
| PM               | Colin Scott     | colin@revelry.co    |
| Tech Lead        | Bryan Joseph    | bryan@revelry.co    |
| Engineer         | Joel Wietelmann | joel@revelry.co     |
| Designer         | Brittany Gay    | brittany@revelry.co |
| QA               | TBD             |
| Business Analyst | TBD             |
| Account Manager  | TBD             |

## Project Setup

Project can be set up by running `sh ./bin/setup`. It does the steps defined below.
Note that Elixir 1.5 or greater is required in order to start it.

Once run, follow directions and start app by running `sh ./bin/server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Tech Stack

- Elixir
- Phoenix Web Framework

#### Explanation

The Phoenix app will manage all things, including GitHub web hooks. Node will be used to process stellar transactions via StellarSDK js client.

### Requirements

Elixir (Language)
Phoenix (Web framework)
node.js (Used to process stellar transactions)
StellarSDK (JavaScript Stellar Client)
