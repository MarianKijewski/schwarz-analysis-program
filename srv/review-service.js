const cds = require('@sap/cds')
const { ref, columns, expand } = cds.ql
const { Status } = require('../@cds-models/sap/cap/orders')

module.exports = cds.service.impl(async function () {
  const { Orders } = this.entities;
  this.on('GET', Orders, async (req) => {
    const [ orderId ] = req.params;
    if (!orderId) {
      req.error(405);
    }

    await UPDATE `Orders` .set `status = ${Status.Received}` .where(orderId)
    // Fetch order with items expanded
    const order = await SELECT.from `Orders` .where(orderId)
      .columns(
        ref`status`,
        expand (ref`Items`, columns`name, quantity, price`)
      )

    if (!order) {
      req.error(404, `Order ${orderId} not found`);
    }

    return order;
  });
})
