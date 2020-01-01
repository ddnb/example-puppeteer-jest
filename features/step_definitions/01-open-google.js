const { Given, When, Then, BeforeAll, AfterAll } = require('cucumber');
var {setDefaultTimeout} = require('cucumber');
setDefaultTimeout(100 * 1000);

// lib
const puppeteer = require('puppeteer');
const expect = require('expect');
const constant = require(`${__base}constant`);

// e2e
let browser;
let page;

BeforeAll(async function() {
  browser = await puppeteer.launch({});
  page = await browser.newPage();
  await page.setViewport({ width: 1440, height: 900 });
});

AfterAll(async function() {
  await page.close();
  await browser.close();
});

Given('Someone want to open google', async function () {
  // Write code here that turns the phrase above into concrete actions
  // return 'pending';
  // BeforeAll with puppeteer configuration
  // Then everything will be PASSED
});

When('Open and goto google web page', async function () {
  // Write code here that turns the phrase above into concrete actions
  // return 'pending';
  await page.goto('https://google.co.jp')
});

Then('Verify that google should open', async function () {
  // Write code here that turns the phrase above into concrete actions
  // return 'pending';
  // take screenshot
  await page.screenshot({path: `${__base}screenshot/01-open-google.png`});
});