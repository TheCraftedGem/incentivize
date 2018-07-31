|  | Build Status |
| ------ | ---- |
| Staging | [![Build Status](https://travis-ci.com/revelrylabs/uniti.svg?token=JiDUwgto8S7TTehG43yL&branch=develop)](https://travis-ci.com/revelrylabs/uniti) |
| Production | [![Build Status](https://travis-ci.com/revelrylabs/uniti.svg?token=JiDUwgto8S7TTehG43yL&branch=develop)](https://travis-ci.com/revelrylabs/uniti) |

**Note:** _The CI badge links in markdown format are located in each TravisCI project by just clicking on the Badge next to the project name_

# Incentivize
Product Owner: Gerard Ramos
* **Project Start Date:** 7-30-18
* **Product Launch Date:** 8-15-18

## Links to relevant docs, repos, etc.
Thing | Location
--- | ---
Waffle Board | [waffle.io](https://waffle.io/revelrylabs/incentivize)
Google Drive | [Project Folder](https://drive.google.com/drive/u/0/folders/1lY2hz6KTeVWQ82HzeTiPBVui6xm3RISs)
Sprint Reports | [Sprint Report Folder](https://drive.google.com/drive/u/0/folders/1vb3BtxN6XlaU38Z-bfh6xluqRG5LRoc2)
Continuous Integration | [TBD]()
Style Guide | [TBD]()
Staging | [TBD]()
Production | [incentivize.io](https://incentivize.io)

## Compatibility Targets
This is currently for Web Only and we will support our standard compatibility targets. 

### Web App Browser Compatibility Targets

OS | Browsers
--- | ---
Windows | IE 11+, Chrome (latest), Firefox (latest), Edge (latest)
Mac | Chrome (latest), Firefox (latest), Safari (latest)
iOS | Safari (latest)
Android | Chrome (latest)

## The Project Brief

### The Idea
Incentivize is a platform that allows companies, repository owners, or interested parties to compensate people for their contributions to open source projects, thus incentivising more contributors to work on those projects.

### Who are we building for?
1) The first are users who want to invest in getting more people contributing to open source projects they have interest in by depositing cryptocurrency([Lumens](https://www.stellar.org/lumens/) for MVP) to be distributed amongst contributors to those projects. 
2) The second are the contributors themselves who would like to receive payment for their contributions to open source projects.

### What is the main problem we are trying to solve?
It can be difficult to maintain and grow Open Source projects. Developers don't get paid for open source work so there is a lack of incentives to make meaningful contributions.

### What is the core loop?
**Repo Admins:** A user with repository admin privleges logs in via GitHub and authorizes the incentivize webhook so that it is available to be incentivized inside of the application.

**Incentivizers:** A user logs in and is able to add cryptocurrency to be distributed to any projects bank that will then be allocated to users who contribute to that project. 

**Contributors:** A user logs in and finds interesting projects to contribute to. They are then rewarded cryptocurrency based on their contributions.

## Nouns & Verbs

### Nouns

### Verbs

## Team

Role | Person | Email
---- | --- | ---
Client | Revelry | gerard@revelry.co
Product Owner | Gerard Ramos | gerard@revelry.co
PM | Colin Scott | colin@revelry.co
Tech Lead | Bryan Joseph | bryan@revelry.co
Engineer | Joel Wietelmann | joel@revelry.co
Designer | Brittany Gay | brittany@revelry.co
QA | TBD |
Business Analyst | TBD |
Account Manager | TBD |

## Project Setup

### Tech Stack
#### Explanation
The Phoenix app will manage all things, including GitHub web hooks. Node will be used to process stellar transactions via StellarSDK js client. 

### Requirements
Elixir (Language)
Phoenix (Web framework)
node.js (Used to process stellar transactions)
StellarSDK (JavaScript Stellar Client)

