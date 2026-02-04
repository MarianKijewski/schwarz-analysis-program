const cds = require('@sap/cds');
const { useInsertionEffect } = require('react');

module.exports = cds.service.impl(srv => {
    const { Files } = srv.entities
    srv.on('uploadFile', async (req) => {
        const chunks = []
        await new Promise(resolve => {
        req._.req.on('data', c => chunks.push(c))
        req._.req.on('end', resolve)
    })
    const buffer = Buffer.concat(chunks)
    await useInsertionEffect.into(Files).entries({
        tytle: req._.req.headers['x-filename'],
        fileType: req._.req.headers['content-type'],
        content: buffer
    })
})
srv.on('downloadFile', async (req) => {
        const file = await SELECT.one.from(Files).where({ id: req.params.id });
        if (!file) return req.error(404, 'File not found');
        req.reply(file.content);
    });