const AWS = require("aws-sdk");
const dotenv = require("dotenv");
dotenv.config();

AWS.config.update({
  accessKeyId: process.env.SES_ACCESS_KEY_ID,
  secretAccessKey: process.env.SES_SECRET_ACCESS_KEY,
});

const ses = new AWS.SES({
  region: process.env.SES_REGION,
});
const sendEmail = (from, to, subject, text) => {
  const params = {
    Destination: {
      ToAddresses: [to]
    },
    Message: {
      Body: {
        Text: {
          Charset: "UTF-8",
          Data: text
        }
      },
      Subject: {
        Charset: 'UTF-8',
        Data: subject
      }
    },
    Source: from
  };

  ses.sendEmail(params, (err, data) => {
    if (err) {
      console.log(err, err.stack);
    } else {
      console.log(data);
    }
  });
}

module.exports = { sendEmail }