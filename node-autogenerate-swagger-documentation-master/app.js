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
      servers: ["http://localhost:5080"]
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
  console.log(req.body.hash);

  res.status(200).send(
    crypto.createHash('sha256')
    .update(Buffer.from(req.body.hash, 'base64')
    .toString('ascii'))
    .digest('hex'));

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
  key: fs.readFileSync('key.pem'),
  cert: fs.readFileSync('cert.pem'),
  passphrase: '7788'
}, app)
.listen(3000);