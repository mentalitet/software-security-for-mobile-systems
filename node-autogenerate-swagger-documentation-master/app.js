const express = require("express");
const app = express();
const swaggerJsDoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");
const crypto = require('crypto');

const port = process.env.PORT || 5080;

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
 *          type: string
 *          format: string
 *    responses:
 *      '200':
 *        description: A successful response
 */
app.post("/hash", (req, res) => {
  console.log(req.body);
  res.status(200).send(
    crypto.createHash('sha256')
    .update(Buffer.from(req.body, 'base64')
    .toString('ascii'))
    .digest('hex'));
});

/**
 * @swagger
 * /:
 *  get:
 *    responses:
 *      '200':
 *       description: A successful response
 */

app.get("/", (req, res) => {
  res.status(200).send("Hellow World");
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
