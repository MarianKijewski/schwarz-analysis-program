//
//
// const cds = require('@sap/cds');
// const nodemailer = require('nodemailer');
//
// module.exports = cds.service.impl(async function() {
//     // Ορισμός των entities από το service
//     const { MyRequests, MyConfirmations, ExtractedData, Suppliers } = this.entities;
//
//     // --- 1. Action: Verify Passcode ---
//     // Ελέγχει αν ο συνδυασμός ID προμηθευτή και κωδικού είναι σωστός
//     this.on('verifyPasscode', async (req) => {
//         const { supplierID, passcode } = req.data;
//
//         if (!supplierID || !passcode) return false;
//
//         // Αναζήτηση στη βάση για τον συγκεκριμένο προμηθευτή
//         const supplier = await SELECT.one.from(Suppliers).where({
//             ID: supplierID,
//             passcode: passcode
//         });
//
//         return !!supplier; // Επιστρέφει true αν βρέθηκε, αλλιώς false
//     });
//
//     // --- 2. READ: MyRequests ---
//     // Ενημερώνει αυτόματα το status σε 'Received' όταν ο supplier βλέπει τις λεπτομέρειες
//     this.on('READ', 'MyRequests', async (req, next) => {
//         const requestId = req.params[0]?.ID || req.params[0];
//         if (!requestId) return next();
//
//         // Ενημέρωση κατάστασης μόνο αν ήταν 'Pending'
//         await UPDATE(MyRequests)
//             .set({
//                 status: 'Received',
//                 receivedAt: new Date().toISOString()
//             })
//             .where({ ID: requestId })
//             .and({ status: 'Pending' });
//
//         // Καταγραφή της κίνησης στον πίνακα επιβεβαιώσεων
//         await INSERT.into(MyConfirmations).entries({
//             request_ID: requestId,
//             action: 'Received',
//             actedBy: req.user?.id || 'Supplier',
//             actedAt: new Date().toISOString()
//         });
//
//         // Επιστροφή των δεδομένων μαζί με τα extracted data και το όνομα του supplier
//         const result = await SELECT.one.from(MyRequests)
//             .where({ ID: requestId })
//             .columns(b => {
//                 b`*`,
//                 b.extractedData(items => {
//                     items.fieldName,
//                     items.fieldValue
//                 }),
//                 b.supplier(s => { s.name, s.ID })
//             });
//
//         if (!result) {
//             return req.error(404, `Request ${requestId} not found`);
//         }
//         return result;
//     });
//
//     // --- 3. Request Actions (Confirm / Reject / Update) ---
//     this.on('confirmRequest', async (req) => {
//         const requestId = req.params[0].ID;
//         const { status } = await SELECT.one.from(MyRequests).where({ ID: requestId });
//         if (status === 'Received' || status === 'Edited') {
//             return UPDATE(MyRequests)
//             .set({ status: 'Confirmed' })
//             .where({ ID: requestId });
//         }
//     });
//
//     this.on('rejectRequest', async (req) => {
//         const requestId = req.params[0].ID;
//         const { status } = await SELECT.one.from(MyRequests).where({ ID: requestId });
//         if (status === 'Received' || status === 'Edited') {
//         return UPDATE(MyRequests)
//             .set({ status: 'Rejected' })
//             .where({ ID: requestId }); }
//     });
//     this.before('UPDATE', 'MyRequests', async (req) => {
//         if (req.data.status && ['Confirmed', 'Rejected'].includes(req.data.status)) {
//             return req.error(400, "Cannot update a request that has already been confirmed or rejected.");
//     }
//         req.data.status = 'Edited';
//     });
//     this.on('confirmExtraction', 'MyRequests', async (req) => {
//         const requestId = req.params[0]?.ID || req.params[0] || req.data?.ID;
//
//         if (!requestId || requestId === 'undefined') {
//             return req.error(400, "Request ID is missing or undefined.");
//         }
//
//         // Ανάκτηση δεδομένων αιτήματος και στοιχείων προμηθευτή
//         const orderData = await SELECT.one.from(MyRequests)
//             .where({ ID: requestId })
//             .columns( b => {
//                 b`*`,
//                 b.supplier( s => { s.name, s.email, s.ID })
//             });
//
//         const items = await SELECT.from(ExtractedData).where({ request_ID: requestId });
//
//         if (!orderData) return req.error(404, `Request ${requestId} not found`);
//
//         // Ενημέρωση σε 'Pending' για να το παραλάβει ο supplier
//         await UPDATE(MyRequests).set({ status: 'Pending' }).where({ ID: requestId });
//
//         await INSERT.into(MyConfirmations).entries({
//             request_ID: requestId,
//             confirmedBy: req.user.id || 'Admin',
//             confirmedDate: new Date().toISOString(),
//             status: 'Confirmed'
//         });
//
//         // Ρύθμιση Nodemailer
//         let transporter = nodemailer.createTransport({
//             service: 'gmail',
//             auth: {
//                 user: process.env.EMAIL_USER,
//                 pass: process.env.EMAIL_PASS
//             }
//         });
//
//         // Δημιουργία δυναμικού Link για το Object Page
//         const protocol = req.headers['x-forwarded-proto'] || 'http';
//         const host = req.headers['x-forwarded-host'] || req.headers.host;
//         const basePath = req._.req.baseUrl || '';
//         const portalLink = `${protocol}://${host}${basePath}/com.schwarz.supplierportal/test/flp.html#app-preview&/MyRequests(ID='${requestId}',IsActiveEntity=true)`;
//
//         const productList = (items && items.length > 0)
//             ? items.map(i => `<li><b>${i.fieldName}:</b> ${i.fieldValue}</li>`).join('')
//             : "<li>No items extracted</li>";
//
//         const mailOptions = {
//             from: '"KAUFLAND Company Portal" <elperperidou@gmail.com>',
//             to: orderData.supplier.email,
//             subject: `Action Required: Extraction Confirmed - Request: ${orderData.requestNumber}`,
//             html: `
//                 <div style="font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
//                     <h2 style="color: #2e7d32;">Extraction Ready for Review</h2>
//                     <p>Hello <b>${orderData.supplier.name}</b>,</p>
//                     <p>Data extraction for request <b>${orderData.requestNumber}</b> is complete.
//                     For security reasons, access is restricted via your personal passcode.</p>
//
//                     <div style="margin: 25px 0; text-align: center;">
//                         <a href="${portalLink}"
//                            style="background-color: #ed1c24; color: white; padding: 14px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
//                            Review & Unlock Details
//                         </a>
//                     </div>
//
//                     <hr style="border: 0; border-top: 1px solid #eee;">
//                 </div>
//             `
//         };
//
//         try {
//             await transporter.sendMail(mailOptions);
//             return {
//                 status: 'Confirmed',
//                 notes: `Email sent with secure link to ${orderData.supplier.email}`,
//                 confirmedDate: new Date().toISOString()
//             };
//         } catch (error) {
//             console.error('Nodemailer Error:', error);
//             return req.error(500, `Confirmation saved, but email dispatch failed: ${error.message}`);
//         }
//     });
// });