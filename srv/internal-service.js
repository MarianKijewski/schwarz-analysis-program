const cds = require('@sap/cds')

class InternalService extends cds.InternalService {
  init() {
    this.before("UPDATE", "Documents", (req) => this.onUpdate(req));

    return super.init();
  }

  async onUpdate (req) {
    let draft = await SELECT.one(1) .from (req.subject) .where `status != 'Draft'`
    if (!draft) req.reject `Can't modify final document!`
  }
}

module.exports = { InternalService }
