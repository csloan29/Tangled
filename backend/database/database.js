var admin = require('./firebase-db');

function createDatabase() {

  this.databaseCodes = {
    SUCCESS: 'SUCCESS',
    DATABASE_ERROR: 'DATABASE_ERROR',
    ENTRY_ALREADY_EXISTS: 'ENTRY_ALREADY_EXISTS',
    ENTRY_DOES_NOT_EXIST: 'ENTRY_DOES_NOT_EXIST'
  }

  //LOCATION DAOS
  this.updateLocationForUser = function(userID, latitude, longitude, onFailure, onSuccess) {
    console.log("database: attempting to update location for user");
    let newPoint = new admin.firestore.GeoPoint(latitude, longitude)
    
    var userRef = admin.firestore().collection("users").doc(userID);
    userRef.update({
      timeline: newPoint
    })
    //Use code below for adding to an array of timeline points
    // userRef.update({
    //   timeline: admin.firestore.FieldValue.arrayUnion(newPoint)
    // })
    .then(function() {
      console.log("database: successful update for user location");
      onSuccess();
      return;
    })
    .catch(function(error) {
      console.log("database: error - could not update location with error: ", error);
      onFailure();
      return;
    })
  }

  this.getSnapshot = function(onFailure, onSuccess) {
    console.log("database: attempting to fetch firebase snapshot");
    var snapshot = admin.firestore().collection("users").get()
    .then(function(snapshot) {
      console.log("database: successful retrieval of firebase snapshot");
      var snap = snapshot;
      onSuccess(snapshot);
      return;
    })
    .catch(function(error) {
      console.log("database: error - could not fetch firebase snapshot with error: ", error);
      onFailure();
      return;
    });
  }

  this.updateMatchesForUser = function(userID, matches) {
    console.log("database: attempting to update matches for user with ID: ", userID);
    admin.firestore().collection("users").doc(userID).update({
      matches: matches
    })
    .then(function() {
      console.log("database: successful update of matches for user");
    })
    .catch(function(error) {
      console.log("database: error - could not update matches for user with error: ", error);
    })
  }

}

//singleton database for all handlers to interact with
module.exports = new createDatabase();