var admin = require('firebase-admin');

var serviceAccount = require('./firebase-admin-sdk.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://tangled-1d133.firebaseio.com",
});

module.exports = admin;