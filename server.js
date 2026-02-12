const cds = require('@sap/cds')

cds.on('bootstrap', (app) => {
  app.get('/', (req, res) => {
    // res.redirect('https://port4004-workspaces-ws-h7mxz.eu30.applicationstudio.cloud.sap/')
    res.redirect('/com.schwarz.providerportal/test/flpSandbox.html#comschwarzproviderportal-tile')
  })
})

module.exports = cds.server

