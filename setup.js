
const chalk = require('chalk')
const puppeteer = require('puppeteer')
const fs = require('fs')
const mkdirp = require('mkdirp')
const os = require('os')
const path = require('path')

const DIR = path.join(os.tmpdir(), 'jest_puppeteer_global_setup')

module.exports = async function() {
  console.log(chalk.green('Setup Puppeteer'))
  const browser = await puppeteer.launch({
    headless: process.env.DEBUG === "1" ? false : true,
    slowMo: process.env.DEBUG === "1" ? 500 : 0,
    devtools: process.env.CONSOLE === "1" ? true : false,
    dumpio: process.env.DEBUG === "1" ? true : false,
    args: process.env.DEBUG === "1" ? [] : ["--no-sandbox", '--disable-setuid-sandbox']
  })
  // This global is not available inside tests but only in global teardown
  global.__BROWSER_GLOBAL__ = browser
  // Instead, we expose the connection details via file system to be used in tests
  mkdirp.sync(DIR)
  fs.writeFileSync(path.join(DIR, 'wsEndpoint'), browser.wsEndpoint())
}