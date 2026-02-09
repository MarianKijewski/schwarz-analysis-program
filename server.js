const cds = require('@sap/cds')

cds.on('bootstrap', (app) => {
  app.get('/', (req, res) => {
    res.redirect('/com.schwarz.providerportal/index.html')
    // Redirects the user to the specified path in the application
    // res.redirect('/com.schwarz.providerportal/test/flpSandbox.html#comschwarzproviderportal-tile')
  })
})

module.exports = cds.server

