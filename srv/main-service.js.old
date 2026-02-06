const cds = require('@sap/cds');

module.exports = async function() {
  const db = await cds.connect.to('db');
  const { Orders, OrderConfirmations, Emails, Suppliers, Providers } = db.entities('com.schwarz.app');

  // Supplier Service Implementation
  this.on('updateOrder', async (req) => {
    const { orderID, updates } = req.data;
    
    // Get the order
    const order = await SELECT.one.from(Orders).where({ ID: orderID });
    
    if (!order) {
      req.error(404, 'Order not found');
      return;
    }
    
    // Only allow updates if order is in Draft or Pending status
    if (order.status !== 'Draft' && order.status !== 'Pending') {
      req.error(400, 'Order cannot be modified in current status');
      return;
    }
    
    try {
      const updateData = JSON.parse(updates);
      
      // Update the order
      await UPDATE(Orders).set(updateData).where({ ID: orderID });
      
      // Return updated order
      return await SELECT.one.from(Orders).where({ ID: orderID });
    } catch (error) {
      req.error(400, 'Invalid update data: ' + error.message);
    }
  });

  this.on('confirmOrder', async (req) => {
    const { orderID } = req.data;
    
    // Get the order
    const order = await SELECT.one.from(Orders).where({ ID: orderID });
    
    if (!order) {
      req.error(404, 'Order not found');
      return;
    }
    
    // Create confirmation
    const confirmation = {
      order_ID: orderID,
      confirmedDate: new Date().toISOString(),
      status: 'Confirmed',
      confirmedBy: req.user.id || 'system'
    };
    
    const result = await INSERT.into(OrderConfirmations).entries(confirmation);
    
    // Update order status
    await UPDATE(Orders).set({ status: 'Confirmed' }).where({ ID: orderID });
    
    // Send confirmation email (mock)
    if (order.supplier_ID) {
      const supplier = await SELECT.one.from(Suppliers).where({ ID: order.supplier_ID });
      if (supplier) {
        await INSERT.into(Emails).entries({
          subject: `Order ${order.orderNumber} Confirmed`,
          body: `Your order ${order.orderNumber} has been confirmed.`,
          sentDate: new Date().toISOString(),
          status: 'Sent',
          recipient: supplier.email,
          sender: 'system@schwarz.com',
          order_ID: orderID,
          supplier_ID: order.supplier_ID
        });
      }
    }
    
    if (order.provider_ID) {
      const provider = await SELECT.one.from(Providers).where({ ID: order.provider_ID });
      if (provider) {
        await INSERT.into(Emails).entries({
          subject: `Order ${order.orderNumber} Confirmed`,
          body: `Your order ${order.orderNumber} has been confirmed.`,
          sentDate: new Date().toISOString(),
          status: 'Sent',
          recipient: provider.email,
          sender: 'system@schwarz.com',
          order_ID: orderID,
          provider_ID: order.provider_ID
        });
      }
    }
    
    return await SELECT.one.from(OrderConfirmations).where({ order_ID: orderID });
  });

  // Before creating an order, set the order number if not provided
  this.before('CREATE', 'Orders', async (req) => {
    if (!req.data.orderNumber) {
      const count = await SELECT.from(Orders).columns('count(*) as count');
      req.data.orderNumber = `ORD-${Date.now()}-${(count[0].count || 0) + 1}`;
    }
    if (!req.data.orderDate) {
      req.data.orderDate = new Date().toISOString();
    }
  });

  // After creating an order, send a notification email
  this.after('CREATE', 'Orders', async (data, req) => {
    if (data.supplier_ID) {
      const supplier = await SELECT.one.from(Suppliers).where({ ID: data.supplier_ID });
      if (supplier) {
        await INSERT.into(Emails).entries({
          subject: `New Order ${data.orderNumber}`,
          body: `A new order ${data.orderNumber} has been created.`,
          sentDate: new Date().toISOString(),
          status: 'Sent',
          recipient: supplier.email,
          sender: 'system@schwarz.com',
          order_ID: data.ID,
          supplier_ID: data.supplier_ID
        });
      }
    }
    
    if (data.provider_ID) {
      const provider = await SELECT.one.from(Providers).where({ ID: data.provider_ID });
      if (provider) {
        await INSERT.into(Emails).entries({
          subject: `New Order ${data.orderNumber}`,
          body: `A new order ${data.orderNumber} has been created.`,
          sentDate: new Date().toISOString(),
          status: 'Sent',
          recipient: provider.email,
          sender: 'system@schwarz.com',
          order_ID: data.ID,
          provider_ID: data.provider_ID
        });
      }
    }
  });
};

