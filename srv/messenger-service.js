const cds = require('@sap/cds');
const nodemailer = require('nodemailer');

module.exports = class MessengerService extends cds.ApplicationService {
    async init() {
        // Συνδεόμαστε απευθείας με τη βάση δεδομένων
        const db = await cds.connect.to('db');
        const { Orders, OrderItems } = db.entities;

        this.on('submitOrder', async (req) => {
            const { orderID } = req.data;

            // 1. SELECT χρησιμοποιώντας το db service (παρακάμπτει το OData 400 error)
            const orderData = await db.run(SELECT.one.from(Orders).where({ ID: orderID }));
            const items = await db.run(SELECT.from(OrderItems).where({ parent_ID: orderID }));

            console.log("--- DEBUG DATA ---");
            console.log("Order found:", orderData);

            if (!orderData) return req.error(404, `Order ${orderID} was not found!`);

            // 2. Setup Nodemailer
            let transporter = nodemailer.createTransport({
                service: 'gmail',
                auth: {
                            user: process.env.EMAIL_USER, 
                            pass: process.env.EMAIL_PASS 
                      }
            });

            const productList = (items && items.length > 0) 
                ? items.map(i => i.product).join(', ') 
                : "No products found";

            const orderLink = `http://localhost:4004/$fiori-preview/MessengerService/S_Orders#preview-app&/?sap-iapp-state=TASM6A6GW9KADTQBGDFPE55AEULRVATKUXLOVVA95`;

            const mailOptions = {
                from: '"KAUFLAND Service" <elperperidou@gmail.com>',
                to: orderData.customerEmail,
                subject: `Delivery Details - Producer: ${orderData.producer}`,
                html: `
                    <div style="font-family: sans-serif; padding: 20px; border: 1px solid #eee;">
                        <h2 style="color: #ed1c24;">Order Confirmation</h2>
                        <p>Hello,</p>
                        <p>Your order from <b>${orderData.producer}</b> is ready.</p>
                        <p><b>Products:</b> ${productList}</p>
                        <br>
                        <a href="${orderLink}" style="background: #ed1c24; color: white; padding: 10px; text-decoration: none; border-radius: 5px;">View Details</a>
                    </div>
                `
            };

            try {
                await transporter.sendMail(mailOptions);
                console.log('--- SUCCESS: Email Sent ---');
                // Επιστρέφουμε ένα απλό string για να μην προσπαθήσει το OData να κάνει πάλι validate object
                return `Success! Email sent to ${orderData.customerEmail}`;
            } catch (error) {
                console.error('--- ERROR ---', error);
                return req.error(500, `Sending failed: ${error.message}`);
            }
        });

        return super.init();
    }
}