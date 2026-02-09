// const cds = require('@sap/cds');
// const nodemailer = require('nodemailer');

// module.exports = cds.service.impl(async function() {
//     // Ορισμός των entities από το service
//     const { MyRequests, MyConfirmations, ExtractedData } = this.entities;

//     /**
//      * ACTION: confirmExtraction
//      * Συμβαίνει όταν ο χρήστης πατάει το κουμπί επιβεβαίωσης στο Portal
//      */
//     this.on('confirmExtraction', 'MyRequests', async (req) => {
//         // 1. Δοκιμάζουμε όλους τους πιθανούς τρόπους για να βρούμε το ID
//         const requestId = req.params[0]?.ID || req.params[0] || req.data?.ID;
        
//         console.log("--- DEBUG: Extracted Request ID:", requestId);

//         if (!requestId || requestId === 'undefined') {
//             return req.error(400, "Request ID is missing or undefined. Check if the action is bound correctly.");
//         }

//         // 2. Ανάκτηση δεδομένων παραγγελίας
//         const orderData = await SELECT.one.from(MyRequests)
//             .where({ ID: requestId })
//             .columns( b => {
//                 b`*`, 
//                 b.supplier( s => { s.name, s.email }) 
//             });
//         // Ανάκτηση των προϊόντων/πεδίων που εξήχθησαν
//         const items = await SELECT.from(ExtractedData).where({ request_ID: requestId });

//         if (!orderData) return req.error(404, `Request ${requestId} not found`);

//         // 3. Ενημέρωση Κατάστασης στην οντότητα MyRequests
//         await UPDATE(MyRequests).set({ status: 'Confirmed' }).where({ ID: requestId });

//         // 4. Καταγραφή της επιβεβαίωσης στον πίνακα MyConfirmations
//         await INSERT.into(MyConfirmations).entries({
//             request_ID: requestId,
//             confirmedBy: req.user.id || 'Admin',
//             confirmedDate: new Date().toISOString(),
//             status: 'Confirmed'
//         });

//         // 5. Ρύθμιση Nodemailer για αποστολή Email
//         // Βεβαιωθείτε ότι έχετε ορίσει τα EMAIL_USER και EMAIL_PASS στο αρχείο .env
//         let transporter = nodemailer.createTransport({
//             service: 'gmail',
//             auth: {
//                 user: process.env.EMAIL_USER, 
//                 pass: process.env.EMAIL_PASS 
//             }
//         });

//         // Δημιουργία λίστας προϊόντων για το σώμα του email
//         const productList = (items && items.length > 0) 
//             ? items.map(i => `<li><b>${i.fieldName}:</b> ${i.fieldValue}</li>`).join('') 
//             : "<li>No items extracted</li>";

//         const mailOptions = {
//             from: '"KAUFLAND Provider Portal" <elperperidou@gmail.com>',
//             to: orderData.supplier.email, // Παραλήπτης είναι ο Supplier της συγκεκριμένης παραγγελίας
//             subject: `Extraction Confirmed - Request: ${orderData.requestNumber}`,
//             html: `
//                 <div style="font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
//                     <h2 style="color: #2e7d32;">Extraction Confirmed!</h2>
//                     <p>Hello <b>${orderData.supplier.name}</b>,</p>
//                     <p>The data extraction for your request <b>${orderData.requestNumber}</b> has been officially confirmed.</p>
//                     <hr style="border: 0; border-top: 1px solid #eee;">
//                     <p><b>Confirmed Extracted Data:</b></p>
//                     <ul>
//                         ${productList}
//                     </ul>
//                     <br>
//                     <p style="font-size: 0.9em; color: #666;">This is an automated notification from the Schwarz IT Provider Portal.</p>
//                 </div>
//             `
//         };

//         // 6. Εκτέλεση αποστολής και επιστροφή απάντησης στο Fiori UI
//         try {
//             await transporter.sendMail(mailOptions);
            
//             // Επιστρέφουμε ένα αντικείμενο που ταιριάζει με το Entity MyConfirmations
//             // για να μην μπερδεύεται το OData
//             return {
//                 status: 'Confirmed',
//                 notes: `Email sent to ${orderData.supplier.email}`,
//                 confirmedDate: new Date().toISOString()
//             };

//         } catch (error) {
//             console.error('Nodemailer Error:', error);
//             // Ακόμα και στο σφάλμα, επιστρέφουμε αντικείμενο ή χρησιμοποιούμε req.error
//             return req.error(500, `Order confirmed, but email failed: ${error.message}`);
//         }
//     });
// });

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
            from: '"KAUFLAND Provider Portal" <elperperidou@gmail.com>',
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