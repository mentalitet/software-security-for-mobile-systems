const express = require("express");
const swaggerJsDoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");
const crypto = require('crypto');
const https = require('https');
const fs = require('fs');

var bodyParser = require('body-parser');


const port = process.env.PORT || 5080;
const app = express();
app.use(bodyParser.json());

// Extended: https://swagger.io/specification/#infoObject
const swaggerOptions = {
  swaggerDefinition: {
    info: {
      version: "1.0.0",
      title: "Demo Swagger API",
      description: "Demo API Information",
      servers: ["https://localhost:3000"]
    }
  },
  // ['.routes/*.js']
  apis: ["app.js"]
};

const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocs));
app.use(express.json())

// Routes
/**
 * @swagger
 * /hash:
 *    post:
 *      description: Use to decode string from base64 and encoded to SHA-256
 *    parameters:
 *      - name: body
 *        in: body
 *        description: string
 *        required: true
 *        schema:
 *          type: object
 *          properties:
 *           hash:
 *              type: "string"
 *    responses:
 *      '200':
 *        description: OK
 *        content:
 *         application/json:
 *          schema:
 *           type: object
 *           properties:
 *            hash:
 *              type: string
 */
app.post("/hash", (req, res) => {
  console.log(req.body.data);

  // res.status(200).send(
  //   crypto.createHash('sha256')
  //   .update(Buffer.from(req.body.data, 'base64')
  //   .toString('ascii'))
  //   .digest('hex'));

  var reqString = crypto.createHash('sha256')
   // updating data 
  .update(Buffer.from(req.body.data, 'base64')
  .toString('ascii'))
  // Encoding to be used 
  .digest('hex');

  res.status(200).json({ hash: reqString})

});


/**
 * @swagger
 * /vhash:
 *    post:
 *      description: Verify that hash equals to hash from data
 *    parameters:
 *      - name: body
 *        in: body
 *        description: string
 *        required: true
 *        schema:
 *          type: object
 *          properties:
 *           hash:
 *              type: string
 *           data:
 *              type: string
 *    responses:
 *      '200':
 *        description: OK
 *        content:
 *         application/json:
 *          schema:
 *           type: object
 *           properties:
 *            status:
 *              type: int
 */
app.post("/vhash", (req, res) => {
  var reqDataToHash = crypto.createHash('sha256')
  // updating data 
  .update(Buffer.from(req.body.data, 'base64')
  .toString('ascii'))
 // Encoding to be used 
  .digest('hex');

  var reqHash = req.body.hash;

  console.log('hashFromReq ' + reqDataToHash)
  console.log('hashFromReq ' + reqHash)

  if(reqDataToHash === reqHash) {
    res.status(200).json({ status: 1})
  }

  else
   res.status(200).json({ status: 0})
});


/**
 * @swagger
 * /:
 *  get:
 *    responses:
 *      '200':
 *        description: OK
 *        content:
 *         application/json:
 *          schema:
 *           type: object
 *           properties:
 *            data:
 *              type: Hellow Worl
 */

app.get("/", (req, res) => {
  res.status(200).send("Hellow World");
});

// we will pass our 'app' to 'https' server
https.createServer({
  key: fs.readFileSync('server101.mycloud.key'),
  cert: fs.readFileSync('server101.mycloud.crt'),
  passphrase: '7788'
}, app)
.listen(3000, () => console.log('Listening....'));