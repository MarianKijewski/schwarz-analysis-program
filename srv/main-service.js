const cds = require('@sap/cds');
const nodemailer = require('nodemailer');

module.exports = cds.service.impl(async function() {
    // Ορισμός των entities από το service
    const { MyRequests, MyConfirmations, ExtractedData } = this.entities;

    /**
     * ACTION: confirmExtraction
     */
    this.on('confirmExtraction', 'MyRequests', async (req) => {
        const requestId = req.params[0]?.ID || req.params[0] || req.data?.ID;
        
        console.log("--- DEBUG: Extracted Request ID:", requestId);

        if (!requestId || requestId === 'undefined') {
            return req.error(400, "Request ID is missing or undefined.");
        }

        // 1. Ανάκτηση δεδομένων
        const orderData = await SELECT.one.from(MyRequests)
            .where({ ID: requestId })
            .columns( b => {
                b`*`, 
                b.supplier( s => { s.name, s.email }) 
            });

        const items = await SELECT.from(ExtractedData).where({ request_ID: requestId });

        if (!orderData) return req.error(404, `Request ${requestId} not found`);

        // 2. Ενημέρωση Βάσης
        await UPDATE(MyRequests).set({ status: 'Confirmed' }).where({ ID: requestId });

        await INSERT.into(MyConfirmations).entries({
            request_ID: requestId,
            confirmedBy: req.user.id || 'Admin',
            confirmedDate: new Date().toISOString(),
            status: 'Confirmed'
        });

        // 3. Nodemailer Setup
        let transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL_USER, 
                pass: process.env.EMAIL_PASS 
            }
        });

        // 4. Δημιουργία Link και Λίστας
        const portalLink = `https://port4004-workspaces-ws-h7mxz.eu30.applicationstudio.cloud.sap/com.schwarz.supplierportal/test/flp.html?sap-ui-xx-viewCache=false#app-preview&/?sap-iapp-state=TAS0H8IILD832D83PKH6OXMZ01FLND8CGAX04U0E1`;

        const productList = (items && items.length > 0) 
            ? items.map(i => `<li><b>${i.fieldName}:</b> ${i.fieldValue}</li>`).join('') 
            : "<li>No items extracted</li>";

        const mailOptions = {
            from: '"KAUFLAND Company Portal" <elperperidou@gmail.com>',
            to: orderData.supplier.email,
            subject: `Extraction Confirmed - Request: ${orderData.requestNumber}`,
            html: `
                <div style="font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
                    <h2 style="color: #2e7d32;">Extraction Confirmed!</h2>
                    <p>Hello <b>${orderData.supplier.name}</b>,</p>
                    <p>The data extraction for your request <b>${orderData.requestNumber}</b> has been officially confirmed.</p>
                    
                    <div style="margin: 20px 0; text-align: center;">
                        <a href="${portalLink}" 
                           style="background-color: #ed1c24; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
                           Open Supplier Portal
                        </a>
                    </div>

                    <hr style="border: 0; border-top: 1px solid #eee;">
                    <p><b>Confirmed Extracted Data:</b></p>
                    <ul>
                        ${productList}
                    </ul>
                    <br>
                    <p style="font-size: 0.8em; color: #666;">If the button above doesn't work, copy and paste this link: <br> ${portalLink}</p>
                </div>
            `
        };

        // 5. Αποστολή
        try {
            await transporter.sendMail(mailOptions);
            return {
                status: 'Confirmed',
                notes: `Email sent to ${orderData.supplier.email}`,
                confirmedDate: new Date().toISOString()
            };
        } catch (error) {
            console.error('Nodemailer Error:', error);
            return req.error(500, `Order confirmed, but email failed: ${error.message}`);
        }
    });
});