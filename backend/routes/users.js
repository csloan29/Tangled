/* NPM packages */
var haversine = require('haversine');
var express = require('express');
var router = express.Router();

var multer = require('multer');
var upload = multer();

/* Local package files */
var tools = require('../resources/tools');
var database = require('../database/database');

//import database codes from database object
var dbCodes = database.databaseCodes;


/**
 * REGISTER NEW USER ROUTE
 * new user infomation required in request body
 */
router.post('/register', upload.array(), function(req, res, next) {
  let userInfo = req.body;
  
  //before registration, check that request is formatted correctly
  let propList = ["email", "password", "name", "sex", "orientation", "latitude", "longitude"];
  if (!tools.objHasAllProperties(userInfo, propList)) {
    //400: bad request
    res.status(400).send({
      message: "register error: missing request parameters for registration",
    });
    return;
  }

  //attempt to register user to database
  database.registerUser(userInfo, onRegisterSuccess, onRegisterFailure);

  function onRegisterSuccess(id) {
      //201: created
      res.status(201).send({
        id: id,
        message: "register successful"
      });
      return;
  }

  function onRegisterFailure(error) {
    if (error === dbCodes.ENTRY_ALREADY_EXISTS) {
      //409: conflict
      res.status(409).send({
        message: "register error: email already exists in database"
      });
      return;
    }
    else if (error === dbCodes.DATABASE_ERROR) {
      //500: internal server error
      res.status(500).send({
        message: "register error: unknown error in database"
      });
      return;
    }
  }

});

/**
 * LOGIN ROUTE
 * email and password required for login authentication in request headers
 */
router.post('/login', function(req, res, next) {
  let email = req.body.email;
  let password = req.body.password;

  //before login, check that request is formatted properly
  if (!email || !password) {
    //400: bad request
    res.status(400).send({
      message: "login error: missing request parameters for login",
    });
    return;
  }

  //attempt to login user with database
  database.loginUser(email, password, onLoginSuccess, onLoginFailure);

  function onLoginSuccess(id) {
    //200: OK
    res.status(200).send({
      id: id,
      message: "login successful"
    });
    return;
  }

  function onLoginFailure(error) {
    if (error === dbCodes.ENTRY_DOES_NOT_EXIST) {
      //404: user not found
      res.status(404).send({
        message: "login error: user entry not found"
      });
      return;
    }
    else if (error === dbCodes.DATABASE_ERROR) {
      //500: internal server error
      res.status(500).send({
        message: "login error: unknown error in database"
      });
      return;
    }
  }

});

/**
 * LOGOUT ROUTE
 * token authentication required in request headers
 */
router.post('/logout', function(req, res, next) {
  let id = req.body.id;

  //check 1: check to make sure token was provided
  if (!id) {
    //400: bad request
    res.status(400).send({
      message: "check 1 logout error: missing request parameters for login",
    });
  }

  //attempt to log out user with database
  database.logoutUser(id, onSuccess, onFailure);

  function onSuccess() {
    //204: no content
    res.sendStatus(204);
  }

  function onFailure(error) {
    if (error === databaseCodes.ENTRY_DOES_NOT_EXIST) {
      //404: not found
    res.status(404).send({
      message: "logout error: user not found"
    });
    }
  }
  
});

module.exports = router;
