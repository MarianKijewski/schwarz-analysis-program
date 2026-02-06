const cds = require('@sap/cds')
const email = require('./aws-ses');
class SendService extends cds.ApplicationService { init() {

  const { Email } = this.entities

  this.on ('sendEmail', async req => {
    let { sender, recipient, link } = req.data
    if (!sender) return req.error (400, `sender has to be set`)
    if (!recipient) return req.error (400, `recipient has to be set`)
    console.log(`sending email from ${sender} to ${recipient}`)

    email.sendEmail(sender, recipient, "test", "test")
  })
}}

module.exports = SendService
