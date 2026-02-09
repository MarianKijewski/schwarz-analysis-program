const cds = require('@sap/cds');
const nodemailer = require('nodemailer');

module.exports = async function() {
    const db = await cds.connect.to('db');
    // NOTE: We now fetch 'Retailers' instead of 'Providers'
    const { DocumentRequests, Emails, Suppliers, Retailers } = cds.entities('com.schwarz.app');

    // Mail Transporter (Mock)
    let transporter = nodemailer.createTransport({
        host: "smtp.ethereal.email", 
        port: 587,
        secure: false, 
        auth: { user: 'test@ethereal.email', pass: 'testpass' }
    });

    // 1. Set Defaults
    this.before('CREATE', 'DocumentRequests', async (req) => {
        if (!req.data.requestNumber) req.data.requestNumber = `REQ-${Date.now()}`;
        req.data.status = 'Pending';
        if (!req.data.requestDate) req.data.requestDate = new Date().toISOString();
    });

    // 2. Send Email to Supplier
    this.after('CREATE', 'DocumentRequests', async (data, req) => {
        const supplier = await SELECT.one.from(Suppliers).where({ ID: data.supplier_ID });

        if (supplier) {
            console.log(`[MAIL BOT] Found Supplier: ${supplier.email}`);
            const secureLink = `https://schwarz-digits.com/portal?token=${data.ID}`;
            
            console.log("----------------------------------------------------");
            console.log(`📧 SENDING MAIL TO: ${supplier.email}`);
            console.log(`🔗 SECURE LINK: ${secureLink}`);
            console.log("----------------------------------------------------");

            await INSERT.into(Emails).entries({
                subject: `Action Required: Request ${data.requestNumber}`,
                body: `Please upload invoice. Link: ${secureLink}`,
                sentDate: new Date().toISOString(),
                status: 'Sent',
                recipient: supplier.email,
                sender: 'system@schwarz.com',
                request_ID: data.ID,
                supplier_ID: supplier.ID
            });
        }
    });

    // 3. Confirm Extraction (Works for both Supplier and Retailer)
    const confirmHandler = async (req) => {
        const requestID = req.params[0].ID || req.params[0]; 
        console.log(`[ACTION] Confirming Request ID: ${requestID}`);
        await UPDATE(DocumentRequests).set({ status: 'Confirmed' }).where({ ID: requestID });
        return { status: 'Confirmed', notes: 'Confirmed via Portal' };
    };

    // Bind action to both services
    this.on('confirmExtraction', 'MyRequests', confirmHandler);
};