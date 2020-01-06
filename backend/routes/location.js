/* NPM packages */
var express = require('express');
var router = express.Router();
var multer = require('multer');
var upload = multer();
var haversine = require('haversine');


/* local package files */
var tools = require('../resources/tools');
var database = require('../database/database');

/** 
 * --------------------
 * LOCATION ROUTES
 * --------------------
 */

/**
 * LOCATION UPDATE ROUTE
 * location information included in request headers
 * 
 * The only interaction the app has with the server is to exchange
 * a new location for a set of new matches
 */
router.post('/update', function(req, res, next) {
  console.log("\nRECEIVED NEW /UPDATE REQUEST");
  //extract expected data
  var userID = req.headers.authorization;
  var latitude = req.body.latitude;
  var longitude = req.body.longitude;
  console.log("/update: Posting new location for user: ", userID);
  console.log("/update: received latitude: ", latitude);
  console.log("/update: received longitude: ", longitude);

  //check 1: check that request is formatted correctly
  if (!userID || !longitude || !latitude) {
    console.log("/update: Error - badly formed request");
    res.status(400).send({
      matches: [],
      message: "location format error: missing request parameters for location update\n" +
                "Required - (headers): authorization, (body): latitude, longitude",
    });
    return;
  }

  //update location
  database.updateLocationForUser(userID, latitude, longitude, onUpdateFailure, onUpdateSuccess);

  function onUpdateFailure() {
    console.log("/update: Error - update failure");
    //500: Server Error
    res.status(500).send({
      matches: [],
      message: "location update error: user could not update user's location",
    });
    return;
  }

  function onUpdateSuccess() {
    console.log("/update: Error - badly formed request");
    //get snapshot of users to loop for matches
    database.getSnapshot(onSnapshotFailure, onSnapshotSuccess);

    function onSnapshotFailure() {
    console.log("/update: Error - failure to get snapshot from firebase");
      //500: Server Error
      res.status(500).send({
        matches: [],
        message: "database fetch error: could not fetch data from  database",
      });
      return;
    }

    function onSnapshotSuccess(snapshot) {
      console.log("/update: Successfully got snapshot from firebase");
      var matches = calculateMatchesForUser(snapshot);
      database.updateMatchesForUser(userID, matches);
      //200: OK
      res.status(200).send({
        matches: matches,
        message: "location update successful: location updated and new match list generated",
      });
      console.log("/update: finished location update and match calculation");
      return;
    }
  }

  function calculateMatchesForUser(snapshot) {

    var matches = [];

    var docs = snapshot.docs;
    for (let i in docs) {
      if (docs[i].id === userID) {
        //do not match user with themselves
        continue;
      }
      var data = docs[i].data();
      if (data.timeline) {
        //create objects for haversine formula
        var userLoc = {
          latitude: latitude,
          longitude: longitude
        }
        //use object below when indexing into an array of timeline values
        // var matchLoc = {
        //   latitude: data.timeline[data.timeline.length - 1].latitude,
        //   longitude: data.timeline[data.timeline.length - 1].longitude
        // }
        var matchLoc = {
          latitude: data.timeline.latitude,
          longitude: data.timeline.longitude
        }
        var withinDistanceFromUser = haversine(userLoc, matchLoc, {unit: 'meter'});
        console.log("DISTANCE: ", withinDistanceFromUser)
        if (withinDistanceFromUser <= 15) {
          data["id"] = docs[i].id;
          data["matchLocation"] = userLoc;
          matches.push(data);
          console.log("NEW MATCH FOUND: ", data);
        }
      }
    }
    return matches;
  }

});

module.exports = router;
