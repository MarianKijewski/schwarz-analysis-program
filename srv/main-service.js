const cds = require('@sap/cds');
const nodemailer = require('nodemailer');

module.exports = async function() {
    // 1. Connect to the Database
    const db = await cds.connect.to('db');
    // We use cds.entities to avoid the deprecation warning
    const { DocumentRequests, Emails, Suppliers } = cds.entities('com.schwarz.app');

    // 2. Setup the Email Transporter (Mock for now)
    let transporter = nodemailer.createTransport({
        host: "smtp.ethereal.email", 
        port: 587,
        secure: false, 
        auth: {
            user: 'test@ethereal.email', 
            pass: 'testpass' 
        }
    });

    // ---------------------------------------------------------------
    // EVENT 1: Before creating, set defaults
    // ---------------------------------------------------------------
    this.before('CREATE', 'DocumentRequests', async (req) => {
        if (!req.data.requestNumber) {
            req.data.requestNumber = `REQ-${Date.now()}`;
        }
        req.data.status = 'Pending';
        if (!req.data.requestDate) {
            req.data.requestDate = new Date().toISOString();
        }
    });

    // ---------------------------------------------------------------
    // EVENT 2: After creating, SEND EMAIL
    // ---------------------------------------------------------------
    this.after('CREATE', 'DocumentRequests', async (data, req) => {
        const supplier = await SELECT.one.from(Suppliers).where({ ID: data.supplier_ID });

        if (supplier) {
            console.log(`[MAIL BOT] Found Supplier: ${supplier.email}`);

            const secureLink = `https://schwarz-digits.com/portal?token=${data.ID}`;

            const mailOptions = {
                from: '"Schwarz Digits System" <system@schwarz.com>',
                to: supplier.email,
                subject: `Action Required: Submit Invoice for Request ${data.requestNumber}`,
                text: `Hello ${supplier.name},\n\nPlease upload your invoice for request ${data.requestNumber}.\n\nClick here to submit: ${secureLink}\n\nRegards,\nSchwarz IT`
            };

            // LOG THE MAIL
            console.log("----------------------------------------------------");
            console.log(`📧 SENDING MAIL TO: ${supplier.email}`);
            console.log(`🔗 SECURE LINK: ${secureLink}`);
            console.log("----------------------------------------------------");

            await INSERT.into(Emails).entries({
                subject: mailOptions.subject,
                body: mailOptions.text,
                sentDate: new Date().toISOString(),
                status: 'Sent',
                recipient: supplier.email,
                sender: 'system@schwarz.com',
                request_ID: data.ID,
                supplier_ID: supplier.ID
            });
        }
    });

    // ---------------------------------------------------------------
    // EVENT 3: The "Confirm Extraction" Action (Bound to Row)
    // ---------------------------------------------------------------
    // Notice the 2nd argument 'MyRequests' - this binds it to the entity
    this.on('confirmExtraction', 'MyRequests', async (req) => {
        // The ID comes from the URL parameters
        const requestID = req.params[0].ID || req.params[0]; 

        console.log(`[ACTION] Confirming Request ID: ${requestID}`);

        // Update the status
        await UPDATE(DocumentRequests).set({ status: 'Confirmed' }).where({ ID: requestID });
        
        return { 
            status: 'Confirmed', 
            notes: 'Automatically confirmed via Supplier Portal' 
        };
    });
};