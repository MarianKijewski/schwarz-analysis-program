const cds = require('@sap/cds')
const email = require('./aws-ses');
class InternalService extends cds.ApplicationService {
  init() {

    const { Documents } = this.entities

    this.before("UPDATE", Documents, (req) => this.onUpdate(req));

    this.on ('sendEmail', Documents, async req => {
      const [ ID ] = req.params;

      const recipient = SELECT.from('Documents', d => {
        d.recipient (r => r.email)
      }).where(ID)
      const content = ID.ID

      if (!recipient) return req.error (400, `recipient has to be set`)
      console.log(`sending ${document} to ${recipient} via email`)

      email.sendEmail(content, recipient)
    })

    return super.init();
  }

  async onUpdate (req) {
    let final = await SELECT.one(1) .from (req.subject) .where `status != 'Draft'`
    if (final) req.reject `Can't modify final document!`
  }
}

module.exports = { InternalService }
