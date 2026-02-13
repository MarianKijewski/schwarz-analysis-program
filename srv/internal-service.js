const cds = require('@sap/cds')
const email = require('./aws-ses');
class InternalService extends cds.ApplicationService {
  init() {
    this.before("UPDATE", "Documents", (req) => this.onUpdate(req));

    this.on ('sendEmail', async req => {
      let { document, recipient } = req.data
      if (!recipient) return req.error (400, `recipient has to be set`)
      console.log(`sending ${document} to ${recipient} via email`)

      email.sendEmail(document, recipient)
    })

    return super.init();
  }

  async onUpdate (req) {
    let draft = await SELECT.one(1) .from (req.subject) .where `status != 'Draft'`
    if (!draft) req.reject `Can't modify final document!`
  }
}

module.exports = { InternalService }
