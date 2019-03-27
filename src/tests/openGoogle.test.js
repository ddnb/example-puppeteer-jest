const timeout = 10000
testName = "open Google homepage"

describe(
  '/ (' + testname + ')',
  () => {
    let page
    beforeAll(async () => {
      page = await global.__BROWSER__.newPage()
      await page.goto('https://google.co.jp')
    }, timeout)

    afterAll(async () => {
      await page.close()
    })

    it('should load without error', async () => {
      let text = await page.evaluate(() => document.body.textContent)
      expect(text).toContain('google')
    })
  },
  timeout
)